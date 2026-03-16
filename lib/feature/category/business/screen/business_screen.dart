import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/business_banner_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/business_popular_service/business_popular_service_bloc.dart';
import '../bloc/business_popular_service/business_popular_service_event.dart';
import '../bloc/business_recommended_service/business_recommended_service_bloc.dart';
import '../bloc/business_recommended_service/business_recommended_service_event.dart';
import '../bloc/business_top_trending_service/business_top_trending_service_bloc.dart';
import '../bloc/business_top_trending_service/business_top_trending_service_event.dart';
import '../repository/business_popular_service_repository.dart';
import '../repository/business_recommended_service_repository.dart';
import '../repository/business_top_trending_service_repository.dart';
import '../widget/bisiness_why_just_our_services_widget.dart';
import '../widget/business_category_widget.dart';
import '../widget/business_high_demand_service_widget.dart';
import '../widget/business_requirement_service_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/business_top_rated_service_widget.dart';

class BusinessScreen extends StatelessWidget {
  final String moduleId;
  final String moduleName;
  const BusinessScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
        BlocProvider(create: (_) => ModuleWiseBannerBloc(ModuleWiseBannerRepository())..add(FetchModuleWiseBanner(moduleId),)),

        BlocProvider(create: (_) => BusinessRecommendedServiceBloc(BusinessRecommendedServiceRepository(),
        )..add(FetchBusinessRecommendedServices(moduleId))),

        BlocProvider(create: (_) => BusinessPopularServiceBloc(BusinessPopularServiceRepository(),
        )..add(FetchBusinessPopularServices(moduleId))),

        BlocProvider(create: (_) => BusinessTopTrendingServiceBloc(BusinessTopTrendingServiceRepository(),
        )..add(FetchBusinessTopTrendingServices(moduleId))),

        BlocProvider(create: (_) => WhyJustOurServiceBloc(WhyJustOurServiceRepository())..add(GetWhyJustOurServiceEvent(moduleId))),


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
                icon:  Icon(Icons.home, color: CustomColor.business,),
                onPressed: () => context.go('/dashboard'),
              ),
              title: Text('Business Service',),
              // leadingWidth: 10,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              flexibleSpace: FlexibleSpaceBar(
                /// background banner
                background: BusinessBannerWidget(moduleId: moduleId, heightBanner: dimensions.screenHeight*0.3,),
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverSearchBarDelegate(
                child: CustomSearchBar(moduleId: moduleId),
                height: 60, // search bar ki height
              ),
            ),

            SliverToBoxAdapter(child:  BusinessCategoryWidget(moduleId: moduleId),),

            SliverToBoxAdapter(child:  BusinessRequirementServiceWidget(moduleId: moduleId),),
            // SliverToBoxAdapter(child: CustomContainer(height: dimensions.screenHeight*0.3,),),
            SliverToBoxAdapter(child:  BusinessHighDemandServiceWidget(moduleId: moduleId),),
            SliverToBoxAdapter(child:  BusinessTopRatedServiceWidget(moduleId: moduleId),),
            SliverToBoxAdapter(child:  BusinessWhyJustOurServicesWidget(moduleId: moduleId,),),

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
