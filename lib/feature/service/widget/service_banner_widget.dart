


import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/service_model.dart';

class ServiceBannerWidget extends StatefulWidget {
  final List<ServiceModel> services;
  const ServiceBannerWidget({super.key, required this.services});

  @override
  State<ServiceBannerWidget> createState() => _ServiceBannerWidgetState();
}

class _ServiceBannerWidgetState extends State<ServiceBannerWidget> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final service = widget.services.first;

    /// Merge thumbnailImage with bannerImages
    final List<String> mergedImages = [
      if (service.thumbnailImage != null && service.thumbnailImage!.isNotEmpty)
        service.thumbnailImage!,
      ...service.bannerImages
    ];

    return Container(
      color: CustomColor.whiteColor,
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: mergedImages.length,
            itemBuilder:(context, index, realIndex) {
              return CustomContainer(
                width: double.infinity,
                networkImg: mergedImages[index],
                borderRadius: false,
                margin: EdgeInsets.zero,
              );
            } ,
            options: CarouselOptions(
              height: dimensions.screenHeight * 0.2,
              scrollPhysics: mergedImages.length > 1
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              autoPlay: mergedImages.length > 1,
              enlargeCenterPage: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 4),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(mergedImages.length, (index) {
              final bool isActive = index == _current;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 4,
                width: isActive ? 24 : 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: isActive
                    ? TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 4), // should match autoPlayInterval
                  builder: (context, value, child) {
                    return FractionallySizedBox(
                      widthFactor: value,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  },
                )
                    : null,
              );
            }),
          ),
          10.height,
        ],
      ),
    );
  }
}
