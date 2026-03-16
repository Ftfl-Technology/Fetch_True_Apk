import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/costants/dimension.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/franchise_banner_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/franchise_popular_service/franchise_popular_service_bloc.dart';
import '../bloc/franchise_popular_service/franchise_popular_service_event.dart';
import '../bloc/franchise_recommended_service/franchise_recommended_service_bloc.dart';
import '../bloc/franchise_recommended_service/franchise_recommended_service_event.dart';
import '../bloc/franchise_top_trending_service/franchise_top_trending_service_bloc.dart';
import '../bloc/franchise_top_trending_service/franchise_top_trending_service_event.dart';
import '../repository/franchise_popular_service_repository.dart';
import '../repository/franchise_recommended_service_repository.dart';
import '../repository/franchise_top_trending_service_repository.dart';
import '../widget/franchise_category_widget.dart';
import '../widget/franchise_most_popular_widget.dart';
import '../widget/franchise_requirement_service_widget.dart';
import '../widget/franchise_top_trending_service_widget.dart';
import '../widget/wjo_franchise_services_widget.dart';


class FranchiseScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  const FranchiseScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  State<FranchiseScreen> createState() => _FranchiseScreenState();
}

class _FranchiseScreenState extends State<FranchiseScreen> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(widget.moduleId),)),
        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(widget.moduleId))),


        BlocProvider(create: (_) => FranchiseRecommendedServiceBloc(FranchiseRecommendedServiceRepository(),
        )..add(FetchFranchiseRecommendedServices(widget.moduleId))),

        BlocProvider(create: (_) => FranchisePopularServiceBloc(FranchisePopularServiceRepository(),
        )..add(FetchFranchisePopularServices(widget.moduleId))),

        BlocProvider(create: (_) => FranchiseTopTrendingServiceBloc(FranchiseTopTrendingServiceRepository(),
        )..add(FetchFranchiseTopTrendingServices(widget.moduleId))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: widget.moduleId))),

      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [

            SliverAppBar(
              // backgroundColor: Colors.white,
              expandedHeight: dimensions.screenHeight*0.3,
              pinned: true,
              titleSpacing: dimensions.screenWidth*0.0,
              leading: IconButton(
                icon:  Icon(Icons.home, color: CustomColor.franchise,),
                onPressed: () => context.go('/dashboard'),
              ),
              title: Text('Franchise Service',),
              // leadingWidth: 10,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              flexibleSpace: FlexibleSpaceBar(
                background:BlocBuilder<CategoryCoverBloc, CategoryCoverState>(
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
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage(item.image),fit: BoxFit.cover)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FranchiseBannerWidget(moduleId: widget.moduleId,),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverSearchBarDelegate(
                child: CustomSearchBar(moduleId: widget.moduleId),
                height: 60, // search bar ki height
              ),
            ),

            SliverToBoxAdapter(
              child: FranchiseCategoryWidget(
                moduleIndexId: widget.moduleId,
              ),
            ),

            SliverToBoxAdapter(
              child: FranchiseRequirementServiceWidget(
                moduleId: widget.moduleId,
              ),
            ),

            SliverToBoxAdapter(
              child: FranchiseMostPopularWidget(
                moduleId: widget.moduleId,
                headline: "Popular Franchise",
              ),
            ),

            SliverToBoxAdapter(
              child: FranchiseTopTrendingServiceWidget(
                moduleId: widget.moduleId,
              ),
            ),

            SliverToBoxAdapter(child: WjoFranchiseServicesWidget(moduleId: widget.moduleId,),),

            const SliverToBoxAdapter(
              child: SizedBox(height: 50),
            ),
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
    return SizedBox(
      height: height,
      child: Material(
        elevation: overlapsContent ? 4 : 0,
        color: Colors.white,
        child: child,
      ),
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
