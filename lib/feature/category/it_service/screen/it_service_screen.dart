import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/feature/category/it_service/widget/it_service_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_search_icon.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/it_service_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../search/screen/search_screen.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/it_popular_service/it_popular_service_bloc.dart';
import '../bloc/it_popular_service/it_popular_service_event.dart';
import '../bloc/it_recommended_service/it_recommended_service_bloc.dart';
import '../bloc/it_recommended_service/it_recommended_service_event.dart';
import '../bloc/it_top_trending_service/it_top_trending_service_bloc.dart';
import '../bloc/it_top_trending_service/it_top_trending_service_event.dart';
import '../repository/it_popular_service_repository.dart';
import '../repository/it_recommended_service_repository.dart';
import '../repository/it_top_trending_service_repository.dart';
import '../widget/it_most_popular_service_widget.dart';
import '../widget/it_recommended_service_widget.dart';
import '../widget/it_top_trending_service_widget.dart';
import '../widget/wsu_widget.dart';


class ItServiceScreen extends StatelessWidget {
  final String moduleId;
  final String moduleName;
  const ItServiceScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(moduleId),)),
        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(moduleId))),

        BlocProvider(create: (_) => ItRecommendedServiceBloc(ItRecommendedServiceRepository(),
        )..add(FetchItRecommendedServices(moduleId))),

        BlocProvider(create: (_) => ItPopularServiceBloc(ItPopularServiceRepository(),
        )..add(FetchItPopularServices(moduleId))),

        BlocProvider(create: (_) => ItTopTrendingServiceBloc(ItTopTrendingServiceRepository(),
        )..add(FetchItTopTrendingServices(moduleId))),

      ],
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 10,),
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [

            SliverAppBar(
            automaticallyImplyLeading: false,
              toolbarHeight: kToolbarHeight,
              backgroundColor: Colors.white,
              expandedHeight: dimensions.screenHeight*0.05,
              pinned: true,
              titleSpacing: dimensions.screenWidth*0.0,
              flexibleSpace: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E9F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                           IconButton(
                            icon:  Icon(Icons.home, color: CustomColor.aiHub,),
                            onPressed: () => context.go('/dashboard'),
                            ),

                            Text('It Service',style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),)
                        ],
                      ),

                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.bookmark_border,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId, status: 'service',),)),

                      ),

                    ],
                  ),

                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16,),),

            SliverToBoxAdapter(child: ItServiceBannerWidget(moduleId: moduleId,)),

            SliverToBoxAdapter(child: SizedBox(height: 16,),),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverSearchBarDelegate(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,top: 5),
                      child: Text('Search According to you ', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                    ),
                    CustomContainer(
                      color: Colors.white,
                      border: true,
                      borderColor: CustomColor.greyColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: dimensions.screenWidth * 0.030,
                        vertical: dimensions.screenHeight * 0.01,
                      ),
                      child: Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomSearchIcon(),
                          Text(
                            "Search here...",
                            style: textStyle14(context, fontWeight: FontWeight.w400),
                          ),

                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen(moduleId: moduleId,)),
                      ),
                    ),
                  ],
                ),
                height: 100, // search bar ki height
              ),
            ),

            SliverToBoxAdapter(child: ItServiceCategoryWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: ItRecommendedServiceWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: ItMostPopularServiceWidget(moduleId: moduleId, headline: 'Most Popular',),),
            SliverToBoxAdapter(child: ItTopTrendingServiceWidget(moduleId: moduleId,),),
            SliverToBoxAdapter(child: WhyChooseUsWidget(moduleId: moduleId,),),
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
      color: Colors.white,
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
