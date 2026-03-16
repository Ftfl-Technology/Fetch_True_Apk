
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/provider/screen/provider__details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../favorite/widget/favorite_provider_button_widget.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../model/provider_model.dart';


class ProviderCategoryWidget extends StatefulWidget {
  final String? moduleId;
  const ProviderCategoryWidget({super.key, this.moduleId});

  @override
  State<ProviderCategoryWidget> createState() => _ProviderCategoryWidgetState();

  /// Static method to provide slivers for parent CustomScrollView
  static List<Widget> slivers(String? moduleId) {
    return [
      SliverPersistentHeader(
        pinned: true,
        delegate: _StickyHeaderDelegate(
          child: _FilterHeaderStatic(moduleId: moduleId),
        ),
      ),
      _ProviderListStatic(moduleId: moduleId),
    ];
  }
}

class _ProviderCategoryWidgetState extends State<ProviderCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    // Scroll is handled by parent; return empty container
    return const SizedBox.shrink();
  }
}

/// StickyHeaderDelegate
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 60;
  @override
  double get maxExtent => 100;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: CustomColor.whiteColor,
      height: (maxExtent - shrinkOffset).clamp(minExtent, maxExtent),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) => true;
}

/// Filter header (static for slivers)
class _FilterHeaderStatic extends StatefulWidget {
  final String? moduleId;
  const _FilterHeaderStatic({super.key, this.moduleId});

  @override
  State<_FilterHeaderStatic> createState() => _FilterHeaderStaticState();
}

class _FilterHeaderStaticState extends State<_FilterHeaderStatic> {
  final providerFilter = ['All', 'Newly Joined', 'Popular', 'Top Rated'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderBloc, ProviderState>(
      builder: (context, state) {
        String selectedFilter = 'All';
        List providers = [];
        if (state is ProvidersLoaded) {
          selectedFilter = state.selectedFilter;
          providers = state.providers
              .where((e) => e.kycCompleted == true && e.storeInfo?.module == widget.moduleId && e.subscribedServices.isNotEmpty)
              .toList();
        }

        // अगर provider list खाली है तो "No Provider" दिखाओ
        if (providers.isEmpty) {
          return SizedBox.shrink();
        }

        int storeCount = providers.length;

        return Container(
          color: CustomColor.whiteColor,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Near By Provider', style: textStyle14(context)),
                  Text('$storeCount Store near you',
                      style: textStyle12(context,
                          fontWeight: FontWeight.w400, color: Colors.grey.shade600)),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: providerFilter.length,
                  itemBuilder: (context, index) {
                    final filter = providerFilter[index];
                    final isSelected = filter == selectedFilter;
                    return GestureDetector(
                      onTap: () {
                        context.read<ProviderBloc>().add(FilterProvidersEvent(filter));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: isSelected ? CustomColor.appColor : Colors.transparent,
                          border: Border.all(color: CustomColor.greyColor, width: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: textStyle12(context,
                                fontWeight: FontWeight.w400,
                                color: isSelected
                                    ? CustomColor.whiteColor
                                    : Colors.grey.shade600),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


/// Provider list (static for slivers)
class _ProviderListStatic extends StatelessWidget {
  final String? moduleId;
  const _ProviderListStatic({this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<ProviderBloc, ProviderState>(
      builder: (context, state) {
        if (state is ProviderLoading) {
          return const SliverToBoxAdapter(
            child: LinearProgressIndicator(minHeight: 2),
          );
        } else if (state is ProvidersLoaded) {
          // List<ProviderModel> providers = state.filteredProviders;
          List<ProviderModel> providers = state.filteredProviders
              .where((e) => e.kycCompleted == true && e.storeInfo?.module == moduleId && e.subscribedServices.isNotEmpty)
              .toList();

          // Filter & Sort
          if (state.selectedFilter != 'All') {
            if (state.selectedFilter == 'Newly Joined') {
              providers = providers.where((e) => e.createdAt != null).toList();
              providers.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            } else if (state.selectedFilter == 'Popular') {
              providers.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
            } else if (state.selectedFilter == 'Top Rated') {
              providers.sort((a, b) => b.averageRating.compareTo(a.averageRating));
            }
          }

          if (providers.isEmpty) {
            // 🔧 Fix here:
            return const SliverToBoxAdapter(
              child: SizedBox.shrink(),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final provider = providers[index];
                return CustomContainer(
                  border: true,
                  margin: const EdgeInsets.only(left: 10, right: 10,top: 10),
                  padding: EdgeInsets.zero,
                  color: CustomColor.whiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomContainer(
                        height:dimensions.screenHeight*0.18,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        networkImg: provider.storeInfo?.cover.toString(),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: FavoriteProviderButtonWidget(providerId: provider.id,),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: CustomColor.appColor,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Visit Provider',
                                  style: textStyle12(context,
                                      color: CustomColor.whiteColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(provider.storeInfo?.storeName ?? 'Store Name', style: textStyle12(context)),
                                Text(
                                  '⭐ ${provider.averageRating} (${provider.totalReviews} Review)',
                                  style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              ],
                            ),
                            5.height,

                            _iconText(context,
                                icon: Icons.alt_route,
                                text: provider.storeInfo?.address ?? 'Address'),
                            _iconText(context, icon: Icons.place, text: '0.00 KM'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProviderDetailsScreen(
                          providerId: provider.id,
                          storeName: provider.storeInfo?.storeName,
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: providers.length,
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

/// Icon + Text helper
Widget _iconText(BuildContext context, {IconData? icon, String? text}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: Colors.green.shade600),
      const SizedBox(width: 5),
      Expanded(
        child: Text(
          text ?? '',
          style: textStyle12(context, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
        ),
      ),
    ],
  );
}