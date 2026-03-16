import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../address/address_notifier.dart';
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

class OnDemandSubcategoryScreen extends StatefulWidget {
  final String categoryName;
  final String moduleId;
  const OnDemandSubcategoryScreen({super.key, required this.categoryName, required this.moduleId});

  @override
  State<OnDemandSubcategoryScreen> createState() => _OnDemandSubcategoryScreenState();
}

class _OnDemandSubcategoryScreenState extends State<OnDemandSubcategoryScreen> {

  bool isNearLocation = false;

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    return MultiBlocProvider(
      providers: [
        // if (lat != null && lng != null)
        BlocProvider(create: (_) => OnDemandPopularProviderBloc(OnDemandPopularProviderRepository())..add(
            FetchOnDemandPopularProviders(
              moduleId: widget.moduleId,
              lat: lat??0.0,
              lng: lng??0.0,))),

        // if (lat != null && lng != null)
        BlocProvider(create: (_) => OnDemandRecommendedProviderBloc(OnDemandRecommendedProviderRepository())..add(
            FetchOnDemandRecommendedProviders(
              moduleId: widget.moduleId,
              lat: lat??0.0,
              lng: lng??0.0,))),

        // if (lat != null && lng != null)
        BlocProvider(create: (_) => OnDemandTopTrendingProviderBloc(OnDemandTopTrendingProviderRepository())..add(
            FetchOnDemandTopTrendingProviders(
              moduleId: widget.moduleId,
              lat: lat??0.0,
              lng: lng??0.0,))),

      ],
      child: Scaffold(

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
                    child:  Icon(Icons.arrow_back_ios, color: CustomColor.onDemand,size: 18,),
                    onTap: () => context.go('/dashboard'),
                  ),
                ),
              ),
              title: Text('${widget.categoryName}',),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
              flexibleSpace: FlexibleSpaceBar(
              ),
            ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverSearchBarDelegate(
                child: CustomSearchBar(moduleId: widget.moduleId),
                height: 60, // search bar ki height
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 10,),),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Near My Location',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Find providers near your area',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    Switch(
                      activeThumbColor: Colors.green,
                      value: isNearLocation,
                      onChanged: (value) {
                        setState(() {
                          isNearLocation = value;
                        });

                        if (value) {
                          print("Near location ON");

                        } else {
                          print("Near location OFF");
                        }
                      },
                    ),

                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: OnDemandRecommendedProviderWidget(),),
            SliverToBoxAdapter(child: OndemandMostPopularProviderWidget(),),
            SliverToBoxAdapter(child: OnDemandTopTrendingProviderWidget(),),
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

