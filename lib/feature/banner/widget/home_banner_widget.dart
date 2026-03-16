import 'dart:async';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/feature/service/screen/service_details_screen.dart';
import 'package:fetchtrue/feature/subcategory/screen/subcategory_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../bloc/banner/banner_bloc.dart';
import '../bloc/banner/banner_state.dart';

class HomeBannerWidget extends StatefulWidget {
  final Function(bool status)? onStatus;
  const HomeBannerWidget({super.key, this.onStatus});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {

  int currentIndex = 0;
  Timer? timer;

  void startAutoSlide(List banners) {
    if (timer != null && timer!.isActive) return;
    timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      setState(() {
        currentIndex = (currentIndex + 1) % banners.length;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BannerBloc, BannerState>(
      listener: (context, state) {
        if (state is BannerLoaded) {
          final banners = state.banners.where((b) => b.page == "home").toList();
          widget.onStatus?.call(banners.isNotEmpty);
        } else if (state is BannerError) {
          widget.onStatus?.call(false);
        }
      },
      child: BlocBuilder<BannerBloc, BannerState>(
        builder: (context, state) {
          if (state is BannerLoading) {
            return Container(color: Colors.grey[100]);
          } else if (state is BannerLoaded) {
            final banners = state.banners.where((b) => b.page == "home").toList();

            if (banners.isEmpty) {
              return const SizedBox.shrink();
            }

            startAutoSlide(banners);
            final banner = banners[currentIndex];

            return Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(seconds: 2),
                  switchInCurve: Curves.easeInCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  child: CustomNetworkImage(
                    key: ValueKey(banner.id),
                    imageUrl: banner.file,
                    fit: BoxFit.cover,
                    onTap: () {
                      if (banner.selectionType == 'referralUrl') {
                        CustomUrlLaunch(banner.referralUrl);
                      } else if (banner.selectionType == 'subcategory') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SubcategoryScreen(
                              categoryId: banner.subcategory!.category!.id,
                              categoryName: banner.subcategory!.category!.name,
                              subcategoryId: banner.subcategory!.id,
                              moduleName: banner.module!.name.toString(),
                            ),
                          ),
                        );
                      } else if (banner.selectionType == 'service') {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => ServiceDetailsScreen(
                        //       serviceId: banner.service!,
                        //         providerId: '',
                        //       isStore: false,
                        //     ),
                        //   ),
                        // );
                      }
                    },
                  ),
                ),

                if (banners.length > 1)
                  Positioned(
                    bottom: 70,
                    left: 15,
                    child: Row(
                      children: List.generate(banners.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 4,
                          width: index == currentIndex ? 24 : 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: index == currentIndex
                              ? TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(seconds: 8),
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
                  ),
              ],
            );
          } else if (state is BannerError) {
            print("Error: ${state.message}");
            return const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

}
