import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:fetchtrue/feature/highlight_serive/repository/ads_repository.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'bloc/ads_bloc.dart';
import 'bloc/ads_event.dart';
import 'bloc/ads_state.dart';



class HighlightServiceWidget extends StatefulWidget {
  final String moduleId;
  const HighlightServiceWidget({super.key, required this.moduleId});

  @override
  State<HighlightServiceWidget> createState() => _HighlightServiceWidgetState();
}

class _HighlightServiceWidgetState extends State<HighlightServiceWidget> {
  int _current = 0;


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => AdsBloc(AdsRepository())..add(LoadAdsEvent()),
      child: BlocBuilder<AdsBloc, AdsState>(
        builder: (context, state) {
          if (state is AdsLoading) {
            return _adsShimmer(dimensions);
          }
          else if (state is AdsLoaded) {
            // final adsList = state.ads.data;

            final adsList = state.ads.where((moduleService) =>
            moduleService.category.module == widget.moduleId && moduleService.isApproved == true).toList();

            if(adsList.isEmpty){
              return SizedBox.shrink();
            }

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Highlight For You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  Column(
                    children: [
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          height: dimensions.screenHeight*0.28,
                          autoPlay: adsList.length == 1 ? false :true,
                          scrollPhysics:adsList.length == 1 ? NeverScrollableScrollPhysics():AlwaysScrollableScrollPhysics(),
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          autoPlayInterval: const Duration(seconds: 4),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        itemCount: adsList.length,
                        itemBuilder: (context, index, realIndex) {
                          final ads = adsList[index];
                          return CustomContainer(
                            border: true,
                            padding: EdgeInsets.zero,
                            color: CustomColor.whiteColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomContainer(
                                    width: double.infinity,
                                    padding: EdgeInsets.zero,
                                    margin: EdgeInsets.zero,
                                    networkImg: ads.fileUrl,
                                    // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceDetailsScreen(serviceId: ads.service.id, providerId: '', isStore: false,),)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ads.title,style: textStyle12(context),),
                                      Text(
                                        ads.description,style: textStyle12(context,fontWeight: FontWeight.w400),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      5.height,

                      if(adsList.length != 1 )
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(adsList.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            height: 5,
                            width: _current == index ? 24 : 10,
                            decoration: BoxDecoration(
                              color: _current == index ? Colors.blueAccent : Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (state is AdsError) {
            debugPrint('${CustomLogEmoji.error} Ads Error : ${state.message}');
            return SizedBox.shrink();
          }
          return Center(child: Text('Press button to load ads'));
        },
      ),
    );
  }
}


Widget _adsShimmer(Dimensions dimensions){
  return  Center(
    child: CustomContainer(
      height: dimensions.screenHeight*0.25,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child:Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
            5.height,
            ShimmerBox(height: 10, width: dimensions.screenHeight*0.15)
          ],
        ),
      ),
    ),
  );
}