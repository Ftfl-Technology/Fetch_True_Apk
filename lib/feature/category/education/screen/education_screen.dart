import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/education/widget/education_category_widget.dart';
import 'package:fetchtrue/feature/category/education/widget/education_requirement_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/education_banner_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/education_popular_service/education_popular_service_bloc.dart';
import '../bloc/education_popular_service/education_popular_service_event.dart';
import '../bloc/education_recommended_service/education_recommended_service_bloc.dart';
import '../bloc/education_recommended_service/education_recommended_service_event.dart';
import '../bloc/education_top_trending_service/education_top_trending_service_bloc.dart';
import '../bloc/education_top_trending_service/education_top_trending_service_event.dart';
import '../repository/education_popular_service_repository.dart';
import '../repository/education_recommended_service_repository.dart';
import '../repository/education_top_trending_service_repository.dart';
import '../widget/education_most_popular_service_widget.dart';
import '../widget/education_top_trending_service_widget.dart';
import '../widget/education_why_just_our_services_widget.dart';

class EducationScreen extends StatelessWidget {
  final String moduleId;
  final String moduleName;
  const EducationScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        // BlocProvider(create: (_) => ModuleByServiceBloc(ModuleByServiceRepository())..add(FetchModuleByServices(moduleId: widget.moduleId,),)),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(moduleId),)),


        BlocProvider(create: (_) => EducationRecommendedServiceBloc(EducationRecommendedServiceRepository(),
        )..add(FetchEducationRecommendedServices(moduleId))),

        BlocProvider(create: (_) => EducationPopularServiceBloc(EducationPopularServiceRepository(),
        )..add(FetchEducationPopularServices(moduleId))),

        BlocProvider(create: (_) => EducationTopTrendingServiceBloc(EducationTopTrendingServiceRepository(),
        )..add(FetchEducationTopTrendingServices(moduleId))),

        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(moduleId))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: moduleId))),


      ],
      child: CustomScrollView(
        slivers: [

          SliverAppBar(
            pinned: true,
            backgroundColor: CustomColor.education,
            expandedHeight: dimensions.screenHeight*0.35,
            titleSpacing: dimensions.screenWidth*0.0,
            leading: IconButton(
              icon:  Icon(Icons.home, color: CustomColor.whiteColor,),
              onPressed: () => context.go('/dashboard'),
            ),
            title: Text('Education Service',),
            // leadingWidth: 10,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: dimensions.screenHeight*0.12,),

                          SizedBox(
                            height: dimensions.screenHeight*0.2,
                            child: EducationBannerWidget(moduleId: moduleId,),
                          )
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
              child: CustomSearchBar(moduleId: moduleId),
              height: 60,
            ),
          ),

          SliverToBoxAdapter(child: EducationCategoryWidget(moduleId: moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
          SliverToBoxAdapter(child: EducationRequirementServiceWidget(moduleId: moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
          SliverToBoxAdapter(child: EducationMostPopularServiceWidget(moduleId: moduleId,headline: 'Most Popular',),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
          SliverToBoxAdapter(child: EducationTopTrendingServiceWidget(moduleId: moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 50,),),
          SliverToBoxAdapter(child: EducationWhyJustOurServicesWidget(moduleId: moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
        ],
      ),
    );
  }
}

class _SliverSearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverSearchBarDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool isSticky = shrinkOffset > 0;

    return Container(
      height: height,
      color: isSticky ? CustomColor.education : Colors.white,
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


