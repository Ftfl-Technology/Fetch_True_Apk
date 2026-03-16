import 'package:fetchtrue/feature/academy/screen/recorded_playlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/recorded_webinar_model.dart';
import '../repository/recorded_webinar_service.dart';

class RecordedWebinarScreen extends StatefulWidget {
  const RecordedWebinarScreen({super.key});

  @override
  State<RecordedWebinarScreen> createState() => _RecordedWebinarScreenState();
}

class _RecordedWebinarScreenState extends State<RecordedWebinarScreen> {

  late Future<RecordedWebinarModel?> _webinarFuture;

  @override
  void initState() {
    super.initState();
    _webinarFuture = RecordedWebinarService().fetchRecordedWebinars();
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Recorded Webinar', showBackButton: true,),

      body: SafeArea(
        child: FutureBuilder<RecordedWebinarModel?>(
          future: _webinarFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildRecordedWebinarShimmer(context);
            }

            if (!snapshot.hasData || snapshot.data?.data.isEmpty == true) {
              return const Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final webinars = snapshot.data!.data;

            return ListView.builder(
              itemCount: webinars.length,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final webinar = webinars[index];

                return  CustomContainer(
                  color: CustomColor.whiteColor,
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContainer(
                        margin: EdgeInsets.zero,
                        networkImg: webinar.imageUrl,
                        height: dimensions.screenHeight*0.18,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              webinar.name,
                              style: textStyle12(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              webinar.description,
                              style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecordedPlaylistScreen(
                        name: webinar.name,
                        videoList: webinar.video,
                      ),
                    ),
                  ),
                );
              },
            );
          },),
      ),
    );
  }
}


Widget _buildRecordedWebinarShimmer(BuildContext context){
  Dimensions dimensions = Dimensions(context);
  return ListView.builder(
    itemCount: 3,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      return CustomContainer(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.zero,
        color: CustomColor.whiteColor,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Thumbnail Placeholder
              CustomContainer(
                height: dimensions.screenHeight * 0.18,
                width: double.infinity,
               color:  Colors.grey.shade300,
                margin: EdgeInsets.zero,
              ),

              // Title & Description
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(height: 10, width: dimensions.screenWidth * 0.5, color: Colors.grey[300], margin: EdgeInsets.zero,),
                    10.height,
                    CustomContainer(height: 10, width: dimensions.screenWidth * 0.7, color: Colors.grey[300], margin: EdgeInsets.zero,),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

