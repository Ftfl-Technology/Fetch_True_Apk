import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/category/franchise/bloc/franchise_popular_service/franchise_popular_service_bloc.dart';
import 'package:fetchtrue/feature/home/repository/mostly_recommended_repository.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../banner/bloc/banner/banner_bloc.dart';
import '../../banner/bloc/banner/banner_event.dart';
import '../../category/ai_hub/bloc/ai_hub_popular_service/ai_hub_popular_service_bloc.dart';
import '../../category/ai_hub/bloc/ai_hub_popular_service/ai_hub_popular_service_event.dart';
import '../../category/ai_hub/repository/ai_hub_popular_service_repository.dart';
import '../../category/education/bloc/education_popular_service/education_popular_service_bloc.dart';
import '../../category/education/bloc/education_popular_service/education_popular_service_event.dart';
import '../../category/education/repository/education_popular_service_repository.dart';
import '../../category/franchise/bloc/franchise_popular_service/franchise_popular_service_event.dart';
import '../../category/franchise/repository/franchise_popular_service_repository.dart';
import '../../category/it_service/bloc/it_popular_service/it_popular_service_bloc.dart';
import '../../category/it_service/bloc/it_popular_service/it_popular_service_event.dart';
import '../../category/it_service/repository/it_popular_service_repository.dart';
import '../../category/legal_service/bloc/legal_popular_service/legal_popular_service_bloc.dart';
import '../../category/legal_service/bloc/legal_popular_service/legal_popular_service_event.dart';
import '../../category/legal_service/repository/legal_popular_service_repository.dart';
import '../../dashboard/screen/dashboard_screen.dart';
import '../../internet/network_wrapper_screen.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../../lead/bloc/lead/lead_state.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/repository/module_repository.dart';
import '../../module/widget/module_widget.dart';
import '../../offer/bloc/offer_bloc.dart';
import '../../offer/bloc/offer_event.dart';
import '../../offer/repository/offer_repository.dart';
import '../../offer/screen/offer_widget.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../rating_review/bloc/give_service_review/give_service_review_bloc.dart';
import '../../rating_review/bloc/give_service_review/give_service_review_event.dart';
import '../../rating_review/bloc/give_service_review/give_service_review_state.dart';
import '../../rating_review/model/give_service_review_model.dart';
import '../../rating_review/screen/ratting_review_screen.dart';
import '../../search/screen/search_screen.dart';
import '../bloc/mostly_popular/mostly_popular_bloc.dart';
import '../bloc/mostly_popular/mostly_popular_event.dart';
import '../bloc/mostly_recommended/mostly_recommended_bloc.dart';
import '../bloc/mostly_recommended/mostly_recommended_event.dart';
import '../bloc/mostly_trending/mostly_trending_bloc.dart';
import '../bloc/mostly_trending/mostly_trending_event.dart';
import '../bloc/top_rated_provider/top_rated_provider_bloc.dart';
import '../bloc/top_rated_provider/top_rated_provider_event.dart';
import '../repository/mostly_popular_repository.dart';
import '../repository/mostly_trending_repository.dart';
import '../repository/top_rated_provider_repository.dart';
import '../widget/appbar_widget.dart';
import '../widget/banner_widget.dart';
import '../widget/mostly_popular_service.dart';
import '../widget/mostly_recommended_service.dart';
import '../widget/mostly_trending_service.dart';
import '../widget/refer_and_earn_widget.dart';
import '../widget/top_reted_provider_widget.dart';
import '../widget/understanding_fetch_true_widget.dart';


class HomeScreen extends StatefulWidget implements BottomNavScreen {
  final int? selectedIndex;
  final void Function(int)? onTabChanged;

  final String? defaultModuleId;
  final String? defaultImageUrl;

  const HomeScreen({super.key, this.selectedIndex, this.onTabChanged, this.defaultModuleId, this.defaultImageUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget copyWith({int? selectedIndex, void Function(int)? onTabChanged}) {
    return HomeScreen(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      onTabChanged: onTabChanged ?? this.onTabChanged,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  final ScrollController _scrollController = ScrollController();

  Future<void> _reloadHome(BuildContext context) async {
    final userSession = Provider.of<UserSession>(context, listen: false);

    context.read<UserBloc>().add(GetUserById(userSession.userId!));
    context.read<ModuleBloc>().add(GetModules());
    context.read<BannerBloc>().add(GetBanners());
    context.read<AiHubPopularServiceBloc>()
        .add(FetchAiHubPopularServices('6822e075e8235364b35df1b4'));
    context.read<FranchisePopularServiceBloc>()
        .add(FetchFranchisePopularServices('68b2caf72ff3f8a31bf7bb8f'));
    context.read<ItPopularServiceBloc>()
        .add(FetchItPopularServices('6822e018e8235364b35df1ab'));
    context.read<LegalPopularServiceBloc>()
        .add(FetchLegalPopularServices('6822dfefe8235364b35df1a5'));
    context.read<EducationPopularServiceBloc>()
        .add(FetchEducationPopularServices('6822e02de8235364b35df1ae'));
    context.read<OfferBloc>().add(FetchOffersEvent());
    context.read<MostlyRecommendedBloc>().add(FetchMostlyRecommended());
    context.read<MostlyPopularBloc>().add(FetchMostlyPopular());
    context.read<MostlyTrendingBloc>().add(FetchMostlyTrending());
    context.read<TopRatedProviderBloc>().add(FetchTopRatedProviders());

    await Future.delayed(const Duration(milliseconds: 800));
  }


  // bool _isCollapsed = false;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(_scrollListener);
  // }
  //
  // void _scrollListener() {
  //   final isCollapsed = _scrollController.offset > 150;
  //   if (isCollapsed != _isCollapsed) {
  //     setState(() => _isCollapsed = isCollapsed);
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   _scrollController.removeListener(_scrollListener);
  //   _scrollController.dispose();
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    Dimensions dimensions = Dimensions(context);
    final double searchBarHeight = dimensions.screenHeight*0.08;
     return NetworkWrapper(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules()),),
                BlocProvider(create: (_) => AiHubPopularServiceBloc(AiHubPopularServiceRepository(),
                )..add(FetchAiHubPopularServices('6822e075e8235364b35df1b4'))),

                BlocProvider(create: (_) => FranchisePopularServiceBloc(FranchisePopularServiceRepository(),
                )..add(FetchFranchisePopularServices('68b2caf72ff3f8a31bf7bb8f'))),

                BlocProvider(create: (_) => ItPopularServiceBloc(ItPopularServiceRepository(),
                )..add(FetchItPopularServices('6822e018e8235364b35df1ab'))),

                BlocProvider(create: (_) => LegalPopularServiceBloc(LegalPopularServiceRepository(),
                )..add(FetchLegalPopularServices('6822dfefe8235364b35df1a5'))),

                BlocProvider(create: (_) => EducationPopularServiceBloc(EducationPopularServiceRepository(),
                )..add(FetchEducationPopularServices('6822e02de8235364b35df1ae'))),

                BlocProvider(create: (_) => OfferBloc(OfferRepository())..add(FetchOffersEvent())),

                BlocProvider(create: (context) => MostlyRecommendedBloc(MostlyRecommendedRepository())..add(FetchMostlyRecommended())),
                BlocProvider(create: (context) => MostlyPopularBloc(MostlyPopularRepository())..add(FetchMostlyPopular())),
                BlocProvider(create: (context) => MostlyTrendingBloc(MostlyTrendingRepository())..add(FetchMostlyTrending())),
                BlocProvider(create: (_) => TopRatedProviderBloc(TopRatedProviderRepository())..add(FetchTopRatedProviders()),),

              ],
              child: Scaffold(
                backgroundColor: Colors.white,
               appBar: AppbarWidget(),
               body:BlocBuilder<ModuleBloc, ModuleState>(
                 builder: (context, moduleState) {
                   if (moduleState is ModuleLoading) {
                     return Column(
                       spacing: 10,
                       children: [
                         Container(
                           color: Color(0xFFF0F5FE),
                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                           child: Row(
                             children: [
                               Expanded(
                                 child: Hero(
                                   tag: "searchBarHero",
                                   child: Material(
                                     color: Colors.transparent,
                                     child: CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         spacing: 10,
                                         children: [
                                           Image.asset(CustomIcon.searchIcon,height: 14,),
                                           Text('Search',style: TextStyle(color: Colors.grey.shade700),)
                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => SearchScreen(moduleId: '')),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),

                               BlocBuilder<UserBloc, UserState>(

                                 builder: (context, state) {
                                   if (state is UserLoading) {
                                     return  CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         children: [
                                           Padding(
                                             padding:  EdgeInsets.only(top: 2.0),
                                             child: Icon(
                                               Icons.verified_outlined,
                                               size: 14,
                                               color:Colors.black,
                                             ),
                                           ),
                                           10.width,
                                           Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => PackageScreen()),
                                       ),
                                     );
                                   }


                                   if (state is UserLoaded) {
                                     final user = state.user;
                                     return  CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         children: [
                                           Padding(
                                             padding:  EdgeInsets.only(top: 2.0),
                                             child: Icon(
                                               Icons.verified_outlined,
                                               size: 14,
                                               color:  user.packageActive == true?CustomColor.appColor:Colors.black,
                                             ),
                                           ),
                                           10.width,
                                           Text('${user.packageActive == true ? user.packageStatus:"Package"}',style: TextStyle(color: user.packageActive == true?CustomColor.appColor:Colors.black,fontWeight: FontWeight.w500),)

                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => PackageScreen()),
                                       ),
                                     );

                                   } else if (state is UserError) {
                                     debugPrint("Error: ${state.massage}");
                                     return  CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         children: [
                                           Padding(
                                             padding:  EdgeInsets.only(top: 2.0),
                                             child: Icon(
                                               Icons.verified_outlined,
                                               size: 14,
                                               color:Colors.black,
                                             ),
                                           ),
                                           10.width,
                                           Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => PackageScreen()),
                                       ),
                                     );
                                   }
                                   return  CustomContainer(
                                     color: Colors.white,
                                     child: Row(
                                       children: [
                                         Padding(
                                           padding:  EdgeInsets.only(top: 2.0),
                                           child: Icon(
                                             Icons.verified_outlined,
                                             size: 14,
                                             color:Colors.black,
                                           ),
                                         ),
                                         10.width,
                                         Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                       ],
                                     ),
                                     onTap: () => Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => PackageScreen()),
                                     ),
                                   );
                                 },
                               )

                             ],
                           ),
                         ),
                         bannerShimmer(dimensions),
                         ModuleShimmer(),
                       ],
                     );
                   }

                   if (moduleState is ModuleError ||
                       (moduleState is ModuleLoaded && moduleState.modules.isEmpty)) {
                     return Column(
                       children: [
                         Container(
                           color: Color(0xFFF0F5FE),
                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                           child: Row(
                             children: [
                               Expanded(
                                 child: Hero(
                                   tag: "searchBarHero",
                                   child: Material(
                                     color: Colors.transparent,
                                     child: CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         spacing: 10,
                                         children: [
                                           Image.asset(CustomIcon.searchIcon,height: 14,),
                                           Text('Search',style: TextStyle(color: Colors.grey.shade700),)
                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => SearchScreen(moduleId: '')),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),

                               BlocBuilder<UserBloc, UserState>(

                                 builder: (context, state) {
                                   if (state is UserLoading) {
                                     return  CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         children: [
                                           Padding(
                                             padding:  EdgeInsets.only(top: 2.0),
                                             child: Icon(
                                               Icons.verified_outlined,
                                               size: 14,
                                               color:Colors.black,
                                             ),
                                           ),
                                           10.width,
                                           Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => PackageScreen()),
                                       ),
                                     );
                                   }


                                   if (state is UserLoaded) {
                                     final user = state.user;
                                     return  CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         children: [
                                           Padding(
                                             padding:  EdgeInsets.only(top: 2.0),
                                             child: Icon(
                                               Icons.verified_outlined,
                                               size: 14,
                                               color:  user.packageActive == true?CustomColor.appColor:Colors.black,
                                             ),
                                           ),
                                           10.width,
                                           Text('${user.packageActive == true ? user.packageStatus:"Package"}',style: TextStyle(color: user.packageActive == true?CustomColor.appColor:Colors.black,fontWeight: FontWeight.w500),)

                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => PackageScreen()),
                                       ),
                                     );

                                   } else if (state is UserError) {
                                     debugPrint("Error: ${state.massage}");
                                     return  CustomContainer(
                                       color: Colors.white,
                                       child: Row(
                                         children: [
                                           Padding(
                                             padding:  EdgeInsets.only(top: 2.0),
                                             child: Icon(
                                               Icons.verified_outlined,
                                               size: 14,
                                               color:Colors.black,
                                             ),
                                           ),
                                           10.width,
                                           Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                         ],
                                       ),
                                       onTap: () => Navigator.push(
                                         context,
                                         MaterialPageRoute(builder: (context) => PackageScreen()),
                                       ),
                                     );
                                   }
                                   return  CustomContainer(
                                     color: Colors.white,
                                     child: Row(
                                       children: [
                                         Padding(
                                           padding:  EdgeInsets.only(top: 2.0),
                                           child: Icon(
                                             Icons.verified_outlined,
                                             size: 14,
                                             color:Colors.black,
                                           ),
                                         ),
                                         10.width,
                                         Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                       ],
                                     ),
                                     onTap: () => Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => PackageScreen()),
                                     ),
                                   );
                                 },
                               )

                             ],
                           ),
                         ),

                         Expanded(
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               const Text(
                                 "Technical Issue",
                                 style: TextStyle(
                                     fontSize: 16,
                                     fontWeight: FontWeight.w500),
                               ),
                               IconButton(
                                 onPressed: () => _reloadHome(context),
                                 icon: const Icon(Icons.refresh),
                               ),
                             ],
                           ),
                         ),
                       ],
                     );
                   }

                   return Stack(
                     children: [
                       Builder(
                           builder: (context) {
                             return RefreshIndicator(
                               color: CustomColor.appColor,
                               onRefresh: () => _reloadHome(context),

                               child:CustomScrollView(
                                 controller: _scrollController,
                                 physics: const AlwaysScrollableScrollPhysics(),
                                 slivers: [
                                   // CustomHomeSliverAppbarWidget(
                                   //   isCollapsed: _isCollapsed,
                                   //   searchBarHeight: searchBarHeight,),


                                   // SliverPersistentHeader(
                                   //   pinned: true,
                                   //   delegate: _SliverSearchBarDelegate(
                                   //     child: AppbarWidget(),
                                   //     height: dimensions.screenHeight*0.065,
                                   //   ),
                                   // ),


                                   SliverAppBar(
                                     snap: false,
                                     floating: true,
                                     pinned: false,
                                     backgroundColor: const Color(0xFFF0F5FE),
                                     automaticallyImplyLeading: false,
                                     elevation: 0,
                                     flexibleSpace:  Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                       child: Row(
                                         children: [
                                           Expanded(
                                             child: Hero(
                                               tag: "searchBarHero",
                                               child: Material(
                                                 color: Colors.transparent,
                                                 child: CustomContainer(
                                                   color: Colors.white,
                                                   child: Row(
                                                     spacing: 10,
                                                     children: [
                                                       Image.asset(CustomIcon.searchIcon,height: 14,),
                                                       Text('Search',style: TextStyle(color: Colors.grey.shade700),)
                                                     ],
                                                   ),
                                                   onTap: () => Navigator.push(
                                                     context,
                                                     MaterialPageRoute(builder: (context) => SearchScreen(moduleId: '')),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ),

                                           BlocBuilder<UserBloc, UserState>(

                                             builder: (context, state) {
                                               if (state is UserLoading) {
                                                 return  CustomContainer(
                                                   color: Colors.white,
                                                   child: Row(
                                                     children: [
                                                       Padding(
                                                         padding:  EdgeInsets.only(top: 2.0),
                                                         child: Icon(
                                                           Icons.verified_outlined,
                                                           size: 14,
                                                           color:Colors.black,
                                                         ),
                                                       ),
                                                       10.width,
                                                       Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                                     ],
                                                   ),
                                                   onTap: () => Navigator.push(
                                                     context,
                                                     MaterialPageRoute(builder: (context) => PackageScreen()),
                                                   ),
                                                 );
                                               }


                                               if (state is UserLoaded) {
                                                 final user = state.user;
                                                 return  CustomContainer(
                                                   color: Colors.white,
                                                   child: Row(
                                                     children: [
                                                       Padding(
                                                         padding:  EdgeInsets.only(top: 2.0),
                                                         child: Icon(
                                                           Icons.verified_outlined,
                                                           size: 14,
                                                           color:  user.packageActive == true?CustomColor.appColor:Colors.black,
                                                         ),
                                                       ),
                                                       10.width,
                                                       Text('${user.packageActive == true ? user.packageStatus:"Package"}',style: TextStyle(color: user.packageActive == true?CustomColor.appColor:Colors.black,fontWeight: FontWeight.w500),)

                                                     ],
                                                   ),
                                                   onTap: () => Navigator.push(
                                                     context,
                                                     MaterialPageRoute(builder: (context) => PackageScreen()),
                                                   ),
                                                 );

                                               } else if (state is UserError) {
                                                 debugPrint("Error: ${state.massage}");
                                                 return  CustomContainer(
                                                   color: Colors.white,
                                                   child: Row(
                                                     children: [
                                                       Padding(
                                                         padding:  EdgeInsets.only(top: 2.0),
                                                         child: Icon(
                                                           Icons.verified_outlined,
                                                           size: 14,
                                                           color:Colors.black,
                                                         ),
                                                       ),
                                                       10.width,
                                                       Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                                     ],
                                                   ),
                                                   onTap: () => Navigator.push(
                                                     context,
                                                     MaterialPageRoute(builder: (context) => PackageScreen()),
                                                   ),
                                                 );
                                               }
                                               return  CustomContainer(
                                                 color: Colors.white,
                                                 child: Row(
                                                   children: [
                                                     Padding(
                                                       padding:  EdgeInsets.only(top: 2.0),
                                                       child: Icon(
                                                         Icons.verified_outlined,
                                                         size: 14,
                                                         color:Colors.black,
                                                       ),
                                                     ),
                                                     10.width,
                                                     Text('${"Package"}',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontSize: 12),)

                                                   ],
                                                 ),
                                                 onTap: () => Navigator.push(
                                                   context,
                                                   MaterialPageRoute(builder: (context) => PackageScreen()),
                                                 ),
                                               );
                                             },
                                           )

                                         ],
                                       ),
                                     ),
                                   ),

                                   SliverToBoxAdapter(child: BannerWidget(),),

                                   SliverToBoxAdapter(
                                     child: ModuleWidget(
                                       selectedIndex: widget.selectedIndex,
                                       onTabChanged: widget.onTabChanged,
                                     ),
                                   ),

                                   SliverToBoxAdapter(child: OfferWidget(),),

                                   SliverToBoxAdapter(child: MostlyRecommendedService(),),
                                   SliverToBoxAdapter(child: ReferAndEarnWidget(),),
                                   SliverToBoxAdapter(child: MostlyTrendingService(),),

                                   SliverToBoxAdapter(child: TopRatedProviderPage(),),

                                   SliverToBoxAdapter(
                                     child: InkWell(
                                         onTap: () => Navigator.push(
                                           context,
                                           MaterialPageRoute(builder: (context) => TeamBuildScreen()),
                                         ),
                                         child: Image.asset('assets/image/team_build_banner.png')),
                                   ),
                                   SliverToBoxAdapter(child: MostlyPopularService(),),

                                   SliverToBoxAdapter(child: UnderstandingFetchTrueWidget(),),
                                   SliverToBoxAdapter(child: SizedBox(height: 1)),

                                 ]
                               ),
                             );
                           }
                       ),

                         Positioned.fill(child: Column(
                           children: [
                             Spacer(),

                             BlocBuilder<LeadBloc, LeadState>(
                               builder: (context, state) {
                                 if (state is! LeadLoaded || state.allLeads.isEmpty) {
                                   return const SizedBox.shrink();
                                 }


                                 final completedLeads = state.allLeads.where((lead) {
                                   return lead.isCompleted == true;
                                 }).toList();

                                 if (completedLeads.isEmpty) {
                                   return const SizedBox.shrink();
                                 }


                                 completedLeads.sort((a, b) {
                                   int aId = int.tryParse(
                                       a.bookingId?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ??
                                       0;
                                   int bId = int.tryParse(
                                       b.bookingId?.replaceAll(RegExp(r'[^0-9]'), '') ?? '0') ??
                                       0;
                                   return bId.compareTo(aId);
                                 });


                                 final lead = completedLeads.first;


                                 if (lead.isSkip == true) {
                                   return const SizedBox.shrink();
                                 }


                                 // isCompleted == true
                                 // isSkip == false
                                 // latest bookingId

                                 return Column(
                                   crossAxisAlignment: CrossAxisAlignment.end,
                                   children: [


                                     BlocListener<GiveServiceReviewBloc, GiveServiceReviewState>(
                                       listener: (context, state) {
                                         if (state is GiveServiceReviewLoading) {
                                           // show loader
                                         }

                                         if (state is GiveServiceReviewSuccess) {
                                           context.read<LeadBloc>().add(FetchLeadsByUser(userSession.userId!));
                                         }

                                         if (state is GiveServiceReviewFailure) {
                                           print(state.error);
                                           showCustomToast(state.error);
                                         }
                                       },
                                       child:  Padding(
                                         padding: const EdgeInsets.only(right: 16.0),
                                         child: InkWell(
                                           child: CircleAvatar(
                                             backgroundColor: Colors.white,
                                             child: Icon(Icons.close,color: Colors.red,),
                                           ),
                                           onTap: () {
                                             context.read<GiveServiceReviewBloc>().add(
                                               GiveSubmitServiceReviewEvent(
                                                 reviewModel: GiveServiceReviewModel(
                                                   userId: userSession.userId!,
                                                   serviceId: lead.service!.id!,
                                                   checkoutId: lead.id!,
                                                   isSkip: true,
                                                   rating: 0,
                                                   comment: "Skip",
                                                 ),
                                               ),
                                             );

                                           },
                                         ),
                                       ),
                                     ),

                                       InkWell(
                                       onTap: () {
                                         Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (_) =>  RatingReviewScreen(
                                               userId: userSession.userId!,
                                               serviceName: lead.service!.serviceName!,
                                               serviceId: lead.service!.id!,
                                               providerId: lead.provider!,
                                               checkoutId: lead.id!,
                                             ),
                                           ),
                                         );
                                       },
                                       child: Container(
                                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                         decoration: BoxDecoration(
                                           color: Colors.white,
                                           borderRadius: BorderRadius.circular(10),
                                           border: Border.all(color: CustomColor.appColor),
                                         ),
                                         child: Row(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Expanded(
                                               child: Row(
                                                 spacing: 10,
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 children: [
                                                   Icon(
                                                     Icons.star_rate_rounded,
                                                     color: Colors.amber,
                                                     size: 30,
                                                   ),
                                               
                                                   Expanded(
                                                     child: Column(
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: [
                                                         Text(
                                                           'Rate this Service',
                                                           style: TextStyle(
                                                               fontSize: 14, fontWeight: FontWeight.w500),
                                                         ),
                                                         Text('${ lead.service?.serviceName}',
                                                           style: const TextStyle(
                                                               fontSize: 14, fontWeight: FontWeight.w500),
                                                         ),
                                                         Text(
                                                           'Share your experience',
                                                           style: TextStyle(
                                                               fontSize: 11, color: Colors.grey),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                             ),
                                             Text(lead.bookingId.toString())
                                           ],
                                         ),
                                       ),
                                     ),
                                   ],
                                 );
                               },
                             ),
                           ],
                         ))
                     ],
                   );
                 },
               ),
                  ),
            ),
          );
  }
}




