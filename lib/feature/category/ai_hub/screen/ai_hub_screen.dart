import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/costants/dimension.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/ai_hub_banner_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/ai_hub_popular_service/ai_hub_popular_service_bloc.dart';
import '../bloc/ai_hub_popular_service/ai_hub_popular_service_event.dart';
import '../bloc/ai_hub_recommended_service/ai_hub_recommended_service_bloc.dart';
import '../bloc/ai_hub_recommended_service/ai_hub_recommended_service_event.dart';
import '../bloc/ai_hub_top_trending_service/ai_hub_top_trending_service_bloc.dart';
import '../bloc/ai_hub_top_trending_service/ai_hub_top_trending_service_event.dart';
import '../repository/ai_hub_popular_service_repository.dart';
import '../repository/ai_hub_recommended_service_repository.dart';
import '../repository/ai_hub_top_trending_service_repository.dart';
import '../widget/ai_hub_category_widget.dart';
import '../widget/ai_hub_live_24_service_widget.dart';
import '../widget/ai_hub_mostly_popular_service_widget.dart';
import '../widget/ai_hub_recommended_service_widget.dart';
import '../widget/ai_hub_top_trending_service_widget.dart';
import '../widget/ai_why_just_our_services_widget.dart';


class AiHubScreen extends StatelessWidget {
  final String moduleId;
  final String moduleName;
  const AiHubScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        // BlocProvider(create: (_) => ModuleByServiceBloc(ModuleByServiceRepository())..add(FetchModuleByServices(moduleId: moduleId,),)),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(moduleId),)),

        BlocProvider(create: (_) => AiHubRecommendedServiceBloc(AiHubRecommendedServiceRepository(),
        )..add(FetchAiHubRecommendedServices(moduleId))),

        BlocProvider(create: (_) => AiHubPopularServiceBloc(AiHubPopularServiceRepository(),
        )..add(FetchAiHubPopularServices(moduleId))),

        BlocProvider(create: (_) => AiHubTopTrendingServiceBloc(AiHubTopTrendingServiceRepository(),
        )..add(FetchAiHubTopTrendingServices(moduleId))),

        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(moduleId))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: moduleId))),

      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [

            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: dimensions.screenHeight*0.35,
              pinned: true,

              titleSpacing: dimensions.screenWidth*0.01,
              title: Row(
                children: [
                  SizedBox(width: dimensions.screenWidth*0.02,),
                  InkWell(
                    child: CircleAvatar(
                      backgroundColor:  Colors.white,
                      child:  Icon(Icons.home, color: CustomColor.aiHub,),
                    ),
                    onTap: () {
                      context.go('/dashboard');
                    },
                  ),
                  SizedBox(width: dimensions.screenWidth*0.03,),
                  Text('Ai Hub',),
                ],
              ),
              leadingWidth: 0,
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
                height: 60, // search bar ki height
              ),
            ),

            SliverToBoxAdapter(child:AiHubBannerWidget(moduleId: moduleId,)),
            SliverToBoxAdapter(child: AiHubCategoryWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: AiHubRecommendedServiceWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: AiHubMostlyPopularServiceWidget(moduleId: moduleId, headline: "Most Popular",),),
            // SliverToBoxAdapter(child: AiHubLive24ServiceWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: AiHubTopTrendingServiceWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: SizedBox(height: 25,),),
            SliverToBoxAdapter(child: AiWhyJustOurServicesWidget(moduleId: moduleId,),),

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
      child: Container(
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
