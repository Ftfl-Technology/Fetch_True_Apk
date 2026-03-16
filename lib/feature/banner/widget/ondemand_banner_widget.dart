import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/widgets/custom_network_mage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../../category/ai_hub/screen/ai_hub_service_details_screen.dart';
import '../../category/business/screen/business_service_details_screen.dart';
import '../../category/education/screen/education_service_details_screen.dart';
import '../../category/finance/screen/finance_service_details_screen.dart';
import '../../category/franchise/screen/franchise_service_details_screen.dart';
import '../../category/it_service/screen/it_service_details_screen.dart';
import '../../category/legal_service/screen/legal_service_details_screen.dart';
import '../../category/marketing/screen/marketing_details_screen.dart';
import '../../category/ondemand/screen/on_demand_service_details_screen.dart';
import '../../subcategory/screen/subcategory_screen.dart';
import '../bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../bloc/module_wise_banner/module_wise_banner_state.dart';

class OndemandBannerWidget extends StatelessWidget {
  final String moduleId;
  const OndemandBannerWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModuleWiseBannerBloc, ModuleWiseBannerState>(
      builder: (context, state) {
        if (state is ModuleWiseBannerLoading) {
          return CustomContainer(
            height: 200,
          );
        }

        if (state is ModuleWiseBannerLoaded) {
          if (state.banners.isEmpty) {
            return const SizedBox.shrink();
          }

          return CarouselSlider.builder(
            itemCount: state.banners.length,
            itemBuilder: (context, index, realIndex) {
              final banner = state.banners[index];

              return CustomNetworkImage(imageUrl: banner.file,
              borderRadius: BorderRadius.circular(10),
                onTap: () {
                  if (banner.selectionType == 'referralUrl') {
                    CustomUrlLaunch(banner.referralUrl!);
                  }
                  else if (banner.selectionType == 'subcategory') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubcategoryScreen(
                          categoryId: banner.screenCategory.toString(),
                          categoryName: banner.screenCategory.toString(),
                          subcategoryId: banner.subCategory.toString(),
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
                },);
            },
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.9,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration:
              const Duration(milliseconds: 800),
            ),
          );
        }

        if (state is ModuleWiseBannerError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
