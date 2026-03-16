import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_search_bar.dart';
import 'package:fetchtrue/feature/category/marketing/widget/marketing_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/marketing_banner_widget.dart';
import '../../../service/bloc/trending_marketing/trending_marketing_bloc.dart';
import '../../../service/bloc/trending_marketing/trending_marketing_event.dart';
import '../../../service/repository/trending_marketing_repository.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/marketing_popular_service/marketing_popular_service_bloc.dart';
import '../bloc/marketing_popular_service/marketing_popular_service_event.dart';
import '../bloc/marketing_recommended_service/marketing_recommended_service_bloc.dart';
import '../bloc/marketing_top_trending_service/marketing_top_trending_service_bloc.dart';
import '../bloc/marketing_top_trending_service/marketing_top_trending_service_event.dart';
import '../repository/marketing_popular_service_repository.dart';
import '../repository/marketing_recommended_service_repository.dart';
import '../repository/marketing_top_trending_service_repository.dart';
import '../widget/marketing_most_popular_service_widget.dart';
import '../widget/marketing_provider_card_widget.dart';
import '../widget/marketing_requirement_service_widget.dart';
import '../widget/marketing_top_trending_service_widget.dart';
import '../widget/why_just_our_services_widget.dart';


class MarketingScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  const MarketingScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(widget.moduleId),)),
        BlocProvider(create: (_) => TrendingMarketingBloc(TrendingMarketingRepository())..add(GetMarketing())),
        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(widget.moduleId))),

        BlocProvider(create: (_) => MarketingRecommendedServiceBloc(MarketingRecommendedServiceRepository(),
        )..add(FetchMarketingRecommendedServices(widget.moduleId))),

        BlocProvider(create: (_) => MarketingPopularServiceBloc(MarketingPopularServiceRepository(),
        )..add(FetchMarketingPopularServices(widget.moduleId))),

        BlocProvider(create: (_) => MarketingTopTrendingServiceBloc(MarketingTopTrendingServiceRepository(),
        )..add(FetchMarketingTopTrendingServices(widget.moduleId))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: widget.moduleId))),

      ],
      child: CustomScrollView(
        slivers: [

          SliverAppBar(
            backgroundColor: CustomColor.marketing,
            expandedHeight: dimensions.screenHeight*0.45,
            pinned: true,
            collapsedHeight: kToolbarHeight + 60,
            titleSpacing: dimensions.screenWidth*0.0,
            leading: IconButton(
              icon:  Icon(Icons.home, color: CustomColor.whiteColor,),
              onPressed: () {
                context.go('/dashboard');
                },
            ),
            title: Text('Marketing Service',),
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
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: dimensions.screenHeight*0.12,),
                          Text(
                            'One Service That you need to\nstand out in market',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: dimensions.screenHeight*0.03,),
                          MarketingBannerWidget(moduleId: widget.moduleId,)
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: CustomSearchBar(moduleId: widget.moduleId,),
              ),
            ),
          ),


          // SliverToBoxAdapter(child: ,),
          SliverToBoxAdapter(child: MarketingCategoryWidget(moduleId: widget.moduleId,),),
          SliverToBoxAdapter(child: MarketingRequirementServiceWidget(moduleId: widget.moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 15,),),
          SliverToBoxAdapter(child: MarketingMostPopularServiceWidget(moduleId: widget.moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 15,),),
          SliverToBoxAdapter(child: MarketingTopTrendingServiceWidget(moduleId: widget.moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
          SliverToBoxAdapter(child: WhyJustOurServicesWidget(moduleId: widget.moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
          SliverToBoxAdapter(child: MarketingProviderCard(moduleId: widget.moduleId,),),
          SliverToBoxAdapter(child: SizedBox(height: 20,),)
        ],
      ),
    );
  }
}

