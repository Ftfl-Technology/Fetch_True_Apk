import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_container.dart';




class AcademyBannerWidget extends StatefulWidget {


  const AcademyBannerWidget({super.key,});

  @override
  State<AcademyBannerWidget> createState() => _AcademyBannerWidgetState();
}

class _AcademyBannerWidgetState extends State<AcademyBannerWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: 2,
          itemBuilder: (context, index, realIndex) {
            return CustomContainer(
              assetsImg: CustomImage.thumbnailImage,
            );
          },
          options: CarouselOptions(
            height: 200,
            autoPlay:  true,
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

        /// 🔘 Dot indicators
        if(2 >1)
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(2, (index) {
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
          ),
      ],
    );
  }
}
