import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_search_icon.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/finance_banner_widget.dart';
import '../../../favorite/screen/favorite_screen.dart';
import '../../../search/screen/search_screen.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/finance_popular_service/finance_popular_service_bloc.dart';
import '../bloc/finance_popular_service/finance_popular_service_event.dart';
import '../bloc/finance_recommended_service/finance_recommended_service_bloc.dart';
import '../bloc/finance_recommended_service/finance_recommended_service_event.dart';
import '../bloc/finance_top_trending_service/finance_top_trending_service_bloc.dart';
import '../bloc/finance_top_trending_service/finance_top_trending_service_event.dart';
import '../repository/finance_popular_service_repository.dart';
import '../repository/finance_recommended_service_repository.dart';
import '../repository/finance_top_trending_service_repository.dart';
import '../widget/finance_best_selling_service_widget.dart';
import '../widget/finance_category_widget.dart';
import '../widget/finance_cost_efficient_service_widget.dart';
import '../widget/finance_recently_added_service_widget.dart';
import '../widget/finance_requirement_service_widget.dart';
import '../widget/what_you_archive_widget.dart';


class FinanceServiceScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  const FinanceServiceScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  State<FinanceServiceScreen> createState() => _FinanceServiceScreenState();
}

class _FinanceServiceScreenState extends State<FinanceServiceScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -8, // up
      end: 8,    // down
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);



    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(widget.moduleId),)),
        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(widget.moduleId))),

        BlocProvider(create: (_) => FinanceRecommendedServiceBloc(FinanceRecommendedServiceRepository(),
        )..add(FetchFinanceRecommendedServices(widget.moduleId))),

        BlocProvider(create: (_) => FinancePopularServiceBloc(FinancePopularServiceRepository(),
        )..add(FetchFinancePopularServices(widget.moduleId))),

        BlocProvider(create: (_) => FinanceTopTrendingServiceBloc(FinanceTopTrendingServiceRepository(),
        )..add(FetchFinanceTopTrendingServices(widget.moduleId))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: widget.moduleId))),

      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: dimensions.screenHeight*0.29,
              pinned: true,
              titleSpacing: dimensions.screenWidth*0.0,
              leading: IconButton(
                icon:  Icon(Icons.home, color: CustomColor.finance,),
                onPressed: () => context.go('/dashboard'),
              ),
              title: Text('Finance Service',),
              // leadingWidth: 10,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              actions: [
                IconButton(
                  icon: Icon(Icons.bookmark, color: CustomColor.finance),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FavoriteScreen(
                          userId: userSession.userId,
                          status: 'service',
                        ),
                      ),
                    );
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(

                background: BlocBuilder<CategoryCoverBloc, CategoryCoverState>(
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
                          children: [
                            SizedBox(height: dimensions.screenHeight*0.1,),

                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _animation.value),
                                  child: child,
                                );
                              },
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/category/finance/finance_cover_img.png',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Smart Financial Decisions for Growing Businesses',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                                  Text('Learn, plan, and control your business ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverSearchBarDelegate(
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(moduleId: widget.moduleId),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: dimensions.screenWidth * 0.030,
                      vertical: dimensions.screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 6), // 👈 only bottom shadow
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomSearchIcon(),
                        10.width,
                        Text(
                          "Search here...",
                          style: textStyle14(
                            context,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height: 60, // search bar ki height
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 20,),),
            SliverToBoxAdapter(
              child: FinanceBannerWidget(moduleId: widget.moduleId,),
            ),
            SliverToBoxAdapter(child: FinanceCategoryWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child: FinanceRequirementServiceWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child: FinanceBestSellingServiceWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child: FinanceRecentlyAddedServiceWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child: WhatYouWillAchieveWidget(moduleId: widget.moduleId,),),
            SliverToBoxAdapter(child: FinanceCostEfficientServiceWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child: SizedBox(height: 50,),)
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
