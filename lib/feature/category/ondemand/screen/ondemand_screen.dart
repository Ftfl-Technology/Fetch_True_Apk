import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_search_bar.dart';
import 'package:fetchtrue/feature/category/ondemand/widget/ondemand_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/dimension.dart';
import '../../../address/address_notifier.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/ondemand_banner_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/on_demand_popular_provider/on_demand_popular_provider_bloc.dart';
import '../bloc/on_demand_popular_provider/on_demand_popular_provider_event.dart';
import '../bloc/on_demand_recommended_provider/on_demand_recommended_provider_bloc.dart';
import '../bloc/on_demand_recommended_provider/on_demand_recommended_provider_event.dart';
import '../bloc/on_demand_top_trending_provider/on_demand_top_trending_provider_bloc.dart';
import '../bloc/on_demand_top_trending_provider/on_demand_top_trending_provider_event.dart';
import '../repository/on_demand_popular_provider_repository.dart';
import '../repository/on_demand_recommended_provider_repository.dart';
import '../repository/on_demand_top_trending_provider_repository.dart';
import '../widget/ondemand_most_popular_provider_widget.dart';
import '../widget/ondemand_recommended_provider_widget.dart';
import '../widget/ondemand_top_trending_provider_widget.dart';
import '../widget/wjoo_demand_service_wdget.dart';


class OnDemandScreen extends StatelessWidget {
  final String moduleId;
  final String moduleName;
  const OnDemandScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    print('lat: $lat');
    print('lng: $lng');

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(moduleId),)),
        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(moduleId))),
        //
        // if (lat != null && lng != null)
        BlocProvider(create: (_) => OnDemandPopularProviderBloc(OnDemandPopularProviderRepository())..add(
            FetchOnDemandPopularProviders(
                moduleId: moduleId,
                lat: lat??0.0,
                lng: lng??0.0,))),

        // if (lat != null && lng != null)
        BlocProvider(create: (_) => OnDemandRecommendedProviderBloc(OnDemandRecommendedProviderRepository())..add(
            FetchOnDemandRecommendedProviders(
              moduleId: moduleId,
              lat: lat??0.0,
              lng: lng??0.0,))),

        // if (lat != null && lng != null)
        BlocProvider(create: (_) => OnDemandTopTrendingProviderBloc(OnDemandTopTrendingProviderRepository())..add(
            FetchOnDemandTopTrendingProviders(
              moduleId: moduleId,
              lat: lat??0.0,
              lng: lng??0.0,))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: moduleId))),


      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(0xFFF6E9E5),
              expandedHeight: dimensions.screenHeight*0.04,
              pinned: true,
              elevation: 0,
              // leadingWidth: 60,
              titleSpacing: dimensions.screenWidth*0.02,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: InkWell(
                    child:  Icon(Icons.home, color: CustomColor.blackColor,),
                    onTap: () => context.go('/dashboard'),
                  ),
                ),
              ),
              title: Text('On-Demand',),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              flexibleSpace: FlexibleSpaceBar(
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverSearchBarDelegate(
                child: CustomSearchBar(moduleId: moduleId),
                height: 60, // search bar ki height
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10,),),

            SliverToBoxAdapter(child: OndemandBannerWidget(moduleId: moduleId,)),

            SliverToBoxAdapter(child: BlocBuilder<CategoryCoverBloc, CategoryCoverState>(
              builder: (context, state) {
                if (state is CategoryCoverLoading || state is CategoryCoverInitial) {
                  return SizedBox.shrink();
                }
                if (state is CategoryCoverFailure) {
                  return  SizedBox.shrink();
                }
                if (state is CategoryCoverSuccess) {
                  final item = state.data.data.first;
                  return Container(
                    height: 150,
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(item.image),fit: BoxFit.cover)
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),),

            SliverToBoxAdapter(child: OnDemandCategoryWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: OnDemandRecommendedProviderWidget(),),
            SliverToBoxAdapter(child: OndemandMostPopularProviderWidget(),),
            SliverToBoxAdapter(child: OnDemandTopTrendingProviderWidget(),),
            SliverToBoxAdapter(child: WjooDemandServiceWdget(moduleId: moduleId,),),
          ],
        ),
      ),
    );

  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverSearchBarDelegate({required this.child, required this.height});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      color: Color(0xFFF6E9E5),
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverSearchBarDelegate oldDelegate) {
    return oldDelegate.child != child || oldDelegate.height != height;
  }
}
