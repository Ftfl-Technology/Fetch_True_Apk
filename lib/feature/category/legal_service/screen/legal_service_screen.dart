import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/category/legal_service/widget/legal_category_widget.dart';
import 'package:fetchtrue/feature/favorite/screen/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_search_icon.dart';
import '../../../auth/user_notifier/user_notifier.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_bloc.dart';
import '../../../banner/bloc/module_wise_banner/module_wise_banner_event.dart';
import '../../../banner/repository/module_wise_banner_repository.dart';
import '../../../banner/widget/legal_banner_widget.dart';
import '../../../search/screen/search_screen.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category_cover/category_cover_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_event.dart';
import '../../repository/category_repository.dart';
import '../../repository/why_just_our_service_repository.dart';
import '../bloc/legal_popular_service/legal_popular_service_bloc.dart';
import '../bloc/legal_popular_service/legal_popular_service_event.dart';
import '../bloc/legal_recommended_service/legal_recommended_service_bloc.dart';
import '../bloc/legal_recommended_service/legal_recommended_service_event.dart';
import '../bloc/legal_top_trending_service/legal_top_trending_service_bloc.dart';
import '../bloc/legal_top_trending_service/legal_top_trending_service_event.dart';
import '../repository/legal_popular_service_repository.dart';
import '../repository/legal_recommended_service_repository.dart';
import '../repository/legal_top_trending_service_repository.dart';
import '../widget/legal_most_popular_service_widget.dart';
import '../widget/legal_requirement_service_widget.dart';
import '../widget/legal_service_spotlight_widget.dart';
import '../widget/legal_top_trending_service_widget.dart';



class LegalServiceScreen extends StatefulWidget {
  final String moduleId;
  final String moduleName;
  const LegalServiceScreen({super.key, required this.moduleId, required this.moduleName});

  @override
  State<LegalServiceScreen> createState() => _LegalServiceScreenState();
}

class _LegalServiceScreenState extends State<LegalServiceScreen> with SingleTickerProviderStateMixin {

  bool showSearch = false;
  late ScrollController _scrollController;


  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !showSearch) {
        setState(() => showSearch = true);
      } else if (_scrollController.offset <= 80 && showSearch) {
        setState(() => showSearch = false);
      }
    });
  }


  @override
  void dispose() {
    _scrollController.dispose();
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

        BlocProvider(create: (_) => LegalRecommendedServiceBloc(LegalRecommendedServiceRepository(),
        )..add(FetchLegalRecommendedServices(widget.moduleId))),

        BlocProvider(create: (_) => LegalPopularServiceBloc(LegalPopularServiceRepository(),
        )..add(FetchLegalPopularServices(widget.moduleId))),

        BlocProvider(create: (_) => LegalTopTrendingServiceBloc(LegalTopTrendingServiceRepository(),
        )..add(FetchLegalTopTrendingServices(widget.moduleId))),

        BlocProvider(create: (_) => CategoryCoverBloc()..add(FetchCategoryCover(moduleId: widget.moduleId))),

      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              toolbarHeight: dimensions.screenHeight*0.07,
              leading: IconButton(
                icon: Icon(Icons.home, color: CustomColor.legal),
                onPressed: () => context.go('/dashboard'),
              ),
              title: Text(
                'Legal Service',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.bookmark, color: CustomColor.legal),
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

              flexibleSpace: AnimatedContainer(duration: Duration(milliseconds: 500),
              margin: showSearch ? EdgeInsets.zero: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFF9F5EE),
              ),),

              bottom: PreferredSize(
                preferredSize: Size.fromHeight(showSearch ? 60 : 0),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: showSearch ? 1 : 0,
                    child: showSearch
                        ? SizedBox(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: CustomContainer(
                          color: Colors.white,
                          border: true,
                          margin: EdgeInsets.all(5),
                          borderColor: Colors.grey.shade400,
                          child: Row(
                            children: [
                              CustomSearchIcon(),
                              10.width,
                              Text(
                                "Search here...",
                                style: textStyle14(
                                  context,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SearchScreen(moduleId: widget.moduleId),
                            ),
                          ),
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),

            ),



            SliverToBoxAdapter(
              child: BlocBuilder<CategoryCoverBloc, CategoryCoverState>(
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
                      height: dimensions.screenHeight*0.25,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage(item.image),fit: BoxFit.cover)
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),


            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF9F5EE),
                      ])
                ),
                child: Column(
                  children: [
                    LegalBannerWidget(moduleId: widget.moduleId,),
                    LegalCategoryWidget(moduleId: widget.moduleId),
                    10.height,
                  ],
                ),
              ),
            ),

            // SliverToBoxAdapter(child:  GetOurLegalExpertsWidget(),),
            SliverToBoxAdapter(child:  LegalRequirementServiceWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child:  LegalMostPopularServiceWidget(moduleId: widget.moduleId,headline: "Most Popular",),),
            SliverToBoxAdapter(child:  LegalTopTrendingServiceWidget(moduleId: widget.moduleId),),
            SliverToBoxAdapter(child:  LegalServiceSpotlightWidget(),),

            SliverToBoxAdapter(child: SizedBox(height: 50,),)
          ],
        ),
      ),
    );
  }
}

