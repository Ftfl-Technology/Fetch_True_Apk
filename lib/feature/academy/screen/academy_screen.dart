import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/widgets/custom_url_launch.dart';
import 'package:fetchtrue/feature/academy/screen/recorded_webinar_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../advisor/screen/adviser_screen.dart';
import '../../internet/network_wrapper_screen.dart';
import '../widget/academy_banner_widget.dart';
import 'training_tutorial_screen.dart';
import 'live_webinar_screen.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  // final String channelId = 'UCKpwgpO9-c_ISAJzNxgHkUw';
  final String channelId = 'UCfpNGM6ncGt-ozIEL0uM7Rg';

  Future<void> _openShorts() async {
    final Uri youtubeAppUrl = Uri.parse('youtube://www.youtube.com/channel/$channelId/shorts');
    final Uri youtubeWebUrl = Uri.parse('https://www.youtube.com/channel/$channelId/shorts');

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl);
    } else {
      throw 'Could not launch YouTube Shorts';
    }
  }

  Future<void> _openPodcast() async {

    final Uri youtubeAppUrl = Uri.parse('youtube://www.youtube.com/channel/$channelId/podcasts');
    final Uri youtubeWebUrl = Uri.parse('https://www.youtube.com/channel/$channelId/podcasts');

    if (await canLaunchUrl(youtubeAppUrl)) {
      await launchUrl(youtubeAppUrl);
    } else if (await canLaunchUrl(youtubeWebUrl)) {
      await launchUrl(youtubeWebUrl);
    } else {
      throw 'Could not launch YouTube Podcasts';
    }
  }



  @override
  Widget build(BuildContext context) {
    final Dimensions dimensions = Dimensions(context);

    final List<Map<String, dynamic>> _services = [
      {
        'title': 'Training Tutorial',
        'icon': Icons.video_camera_back_outlined,
        'screenBuilder': () => TrainingTutorialScreen(),
      },
      {
        'title': '2 Min. Gyan',
        'icon': Icons.lightbulb_outline,
        'screenBuilder': _openShorts,
      },
      {
        'title': 'Live Webinar',
        'icon': Icons.wifi,
        'screenBuilder': () => LiveWebinarScreen(),
      },
      {
        'title': 'Recorded Webinar',
        'icon': Icons.video_library,
        'screenBuilder': () => RecordedWebinarScreen(),
      },
      // {
      //   'title': 'Documents',
      //   'icon': Icons.insert_drive_file,
      //   'screenBuilder': () => DocumentScreen(),
      // },
      {
        'title': 'Podcast',
        'icon': Icons.podcasts,
        'screenBuilder': _openPodcast,
      },
    ];

    return NetworkWrapper(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Academy',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: dimensions.screenHeight*0.02),
                 CustomContainer(
                   height: dimensions.screenHeight*0.2,
                   color: WidgetStateColor.transparent,
                   padding: const EdgeInsets.all(20.0),
                   assetsImg: 'assets/image/academy_contact_for_biz.jpg',
                   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AdviserScreen(),)),
                 ),

                 Padding(
                   padding:  EdgeInsets.only(top: dimensions.screenHeight*0.02,left: dimensions.screenHeight*0.01, bottom: dimensions.screenHeight*0.02),
                   child: Text('Learn, Grow & Build Your Business', style: textStyle14(context, fontWeight: FontWeight.w400),),
                 ),

                 /// Grid of services
                 GridView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: _services.length,
                   padding: EdgeInsets.symmetric(horizontal: 15),
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3,
                     childAspectRatio: 1.11 / 1,
                     mainAxisSpacing: 10,
                     crossAxisSpacing: 10,
                   ),
                   itemBuilder: (context, index) {
                     final item = _services[index];

                     return CustomContainer(
                       border: false,
                       color: Colors.white,
                       padding: EdgeInsets.zero,
                       margin: EdgeInsets.zero,
                       onTap: () async {
                         final screenBuilder = item['screenBuilder'];

                         if (screenBuilder is Widget Function()) {
                           // Navigate normally
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => screenBuilder()),
                           );
                         } else if (screenBuilder is Function) {
                           // Call function (like _openShorts)
                           await screenBuilder();
                         }
                       },
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           Expanded(
                             child: CustomContainer(
                               color: Colors.transparent,
                               child: Icon(
                                 item['icon'] as IconData,
                                 size: 30,
                                 color: CustomColor.appColor,
                               ),
                             ),
                           ),
                           Padding(
                             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                             child: Text(
                               item['title'] as String,
                               style: const TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w500,
                               ),
                               textAlign: TextAlign.center,
                             ),
                           ),
                         ],
                       ),
                     );
                   },
                 ),
               ],
             ),


              Padding(
                padding:  EdgeInsets.only(bottom: 50.0),
                child: Row(
                spacing: dimensions.screenWidth*0.05,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                     CustomUrlLaunch('https://www.youtube.com/@FetchTrue');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(CustomIcon.youtubeIcon),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 30,
                      width: 30,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      CustomUrlLaunch('https://www.instagram.com/fetchtrue');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(CustomIcon.instagramIcon),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 30,
                      width: 30,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      CustomUrlLaunch('https://www.instagram.com/fetchtrue');
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(CustomIcon.facebookIcon),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 30,
                      width: 30,
                    ),
                  ),
                ],

                ),
              )
          ],
        ),
      ),
    );
  }
}
