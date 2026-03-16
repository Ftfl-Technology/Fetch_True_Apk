import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/subcategory/screen/subcategory_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../../banner/bloc/banner/banner_bloc.dart';
import '../../banner/bloc/banner/banner_state.dart';
import '../../category/ai_hub/screen/ai_hub_service_details_screen.dart';
import '../../category/business/screen/business_service_details_screen.dart';
import '../../category/education/screen/education_service_details_screen.dart';
import '../../category/finance/screen/finance_service_details_screen.dart';
import '../../category/franchise/screen/franchise_service_details_screen.dart';
import '../../category/it_service/screen/it_service_details_screen.dart';
import '../../category/legal_service/screen/legal_service_details_screen.dart';
import '../../category/marketing/screen/marketing_details_screen.dart';
import '../../category/ondemand/screen/on_demand_service_details_screen.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key,});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {

        if (state is BannerLoading) {
          return bannerShimmer(dimensions);

        }

        if (state is BannerLoaded) {
          final banners = state.banners.where((b) => b.page == "home").toList();

          if (banners.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: banners.length,
                  itemBuilder: (context, index, realIndex) {
                    final banner = banners[index];

                    return CustomNetworkImage(
                      imageUrl: banner.file,
                      fit: BoxFit.fill,
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (banner.selectionType == 'referralUrl') {
                          CustomUrlLaunch(banner.referralUrl);
                        }
                        else if (banner.selectionType == 'subcategory') {
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
                        }
                        else if (banner.selectionType == 'service') {

                          switch (banner.module!.id) {
                            case "68b2caf72ff3f8a31bf7bb8f":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FranchiseServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822dfd5e8235364b35df1a2":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MarketingDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822dfbce8235364b35df19f":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BusinessServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822dfd5e8235364b35df1a2":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EducationServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822dfefe8235364b35df1a5":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LegalServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822e003e8235364b35df1a8":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FinanceServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822e075e8235364b35df1b4":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AiHubServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822e018e8235364b35df1ab":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ItServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            case "6822e05ee8235364b35df1b1":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OnDemandServiceDetailsScreen(
                                    serviceId: banner.service!,
                                    serviceName: banner.service!,
                                  ),
                                ),
                              );
                              break;

                            default:
                              showCustomSnackBar(context,'Module not supported');
                          }
                        }
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: dimensions.screenHeight*0.22,
                    viewportFraction: 1,
                    autoPlay: banners.length > 1,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),

                if (banners.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 10,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 6,
                          width: currentIndex == index ? 22 : 8,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? Colors.blueAccent
                                : Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        if (state is BannerError) {
          print('Banner Error ${state.message}');
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}

Widget bannerShimmer(Dimensions dimensions) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: dimensions.screenHeight*0.22,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
