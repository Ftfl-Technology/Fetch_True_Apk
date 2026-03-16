import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_network_mage.dart';
import 'package:fetchtrue/feature/favorite/widget/favorite_service_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../category/ai_hub/screen/ai_hub_service_details_screen.dart';
import '../../category/business/screen/business_service_details_screen.dart';
import '../../category/education/screen/education_service_details_screen.dart';
import '../../category/finance/screen/finance_service_details_screen.dart';
import '../../category/franchise/screen/franchise_service_details_screen.dart';
import '../../category/it_service/screen/it_service_details_screen.dart';
import '../../category/legal_service/screen/legal_service_details_screen.dart';
import '../../category/marketing/screen/marketing_details_screen.dart';
import '../../category/ondemand/screen/on_demand_service_details_screen.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../bloc/provider_category/provider_category_bloc.dart';
import '../bloc/provider_category/provider_category_event.dart';
import '../bloc/provider_category/provider_category_state.dart';
import '../bloc/provider_subscribe_service/provider_subscribe_bloc.dart';
import '../bloc/provider_subscribe_service/provider_subscribe_event.dart';
import '../bloc/provider_subscribe_service/provider_subscribe_state.dart';
import '../model/provider_model.dart';
import '../repository/provider_category_repository.dart';
import '../repository/provider_repository.dart';
import '../repository/provider_subscribe_service_repo.dart';
import '../widget/gallery_widget.dart';
import '../widget/provider_review_widget.dart';


class ProviderDetailsScreen extends StatefulWidget {
  final String? providerId;
  final String? storeName;
  const ProviderDetailsScreen({super.key, this.storeName, this.providerId});

  @override
  State<ProviderDetailsScreen> createState() => _ProviderDetailsScreenState();
}

class _ProviderDetailsScreenState extends State<ProviderDetailsScreen>  with SingleTickerProviderStateMixin{

  final List<Tab> myTabs = const [
    Tab(text: 'Services'),
    Tab(text: 'Reviews'),
    Tab(text: 'About'),
    Tab(text: 'Gallery'),
  ];


  int selectedCategoryIndex = -1;
  bool isAllSelected = true;

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: myTabs.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      setState(() {});
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviderById(widget.providerId!))),
        BlocProvider(create: (_) => ProviderCategoryBloc(ProviderCategoryRepository())..add(FetchProviderCategories(widget.providerId!))),
        BlocProvider(create: (_) => ProviderSubscribeBloc(ProviderSubscribeServiceRepo())..add(FetchSubscribedServices(widget.providerId!)))
      ],
      child: Scaffold(
        backgroundColor: Colors.white,

        body: DefaultTabController(
          length: myTabs.length,
          child: MultiBlocListener(
            listeners: [
              BlocListener<ProviderBloc, ProviderState>(listener: (context, state) {
                if (state is ProviderError) debugPrint('Provider Error: ${state.message}');
              },),


              BlocListener<ProviderCategoryBloc, ProviderCategoryState>(listener: (context, state) {
                if (state is ProviderCategoryError) debugPrint('Provider category Error: ${state.message}');
              },),

            ],
            child: Builder(
              builder: (context) {
                final providerState = context.watch<ProviderBloc>().state;
                final providerCategoryState = context.watch<ProviderCategoryBloc>().state;

                if(providerState is ProviderLoading || providerCategoryState is ProviderCategoryLoading){
                  return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
                }


                if (providerState is ProviderLoaded && providerCategoryState is ProviderCategoryLoaded) {
                  final provider = providerState.provider;
                  final providerCategory = providerCategoryState.categories;


                  // provider safe fetch
                  final selectedProvider = (provider != null && provider.kycCompleted == true) ? provider : null;

                  if (selectedProvider == null) {
                    return const Center(child: Text("Provider not available"));
                  }


                  return CustomScrollView(
                    controller: _scrollController,

                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        collapsedHeight: 0,
                        toolbarHeight: 0,
                        expandedHeight: dimensions.screenHeight * 0.25,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        flexibleSpace: LayoutBuilder(
                          builder: (context, constraints) {

                            final top = constraints.biggest.height;
                            bool isCollapsed = top <= kToolbarHeight + MediaQuery.of(context).padding.top;

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                  opacity: isCollapsed ? 0.0 : 1.0,
                                  child: provider.storeInfo!.cover.isNotEmpty
                                      ? Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: _getImageProvider(provider.storeInfo?.cover),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                      : Container(color: Colors.grey),
                                ),

                                if (isCollapsed)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.white,
                                    ),
                                  ),

                                Positioned(
                                  top: MediaQuery.of(context).padding.top + 8,
                                  left: 8,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: isCollapsed ? 0.0 : 1.0, // hide on collapse
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black.withOpacity(0.1),
                                      radius: 18,
                                      child: IconButton(
                                        icon:  Icon(Icons.arrow_back, color: CustomColor.marketing),
                                        onPressed: () => Navigator.of(context).pop(),
                                        iconSize: 20,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            );
                          },
                        ),
                      ),

                       SliverPersistentHeader(
                         pinned: true,
                         delegate: _StickyHeaderDelegate(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Center(child: _profileCard(data: provider,storeName: widget.storeName)),
                               TabBar(
                                 controller: _tabController,
                                 isScrollable: true,
                                 labelPadding:
                                 const EdgeInsets.symmetric(horizontal: 16),
                                 labelColor: Colors.blueAccent,
                                 unselectedLabelColor: Colors.black54,
                                 indicatorColor: Colors.blueAccent,
                                 tabAlignment: TabAlignment.start,
                                 tabs: myTabs,
                               ),


                               if (_tabController.index == 0)
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text('Category',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                               ),

                               if (_tabController.index == 0)
                               providerCategory.isNotEmpty
                                   ? SingleChildScrollView(
                                   scrollDirection: Axis.horizontal,
                                     child: Row(
                                       children: [
                                     // ALL button
                                     CustomContainer(
                                       margin: const EdgeInsets.only(left: 10),
                                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                       color: isAllSelected ? CustomColor.appColor : Color(0xFFF8F8F8),
                                       child: Center(child: Text('All', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color:  isAllSelected ? CustomColor.whiteColor : CustomColor.blackColor))),
                                       onTap: () {
                                         setState(() {
                                           isAllSelected = true;
                                           selectedCategoryIndex = -1; // deselect other categories
                                         });
                                       },
                                     ),
                                     Row(
                                       children: List.generate(providerCategory.length, (index) {
                                         final category = providerCategory[index];
                                         return CustomContainer(
                                           padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                           color: selectedCategoryIndex == index ? CustomColor.appColor :  Color(0xFFF8F8F8),
                                           margin: const EdgeInsets.only(left: 10),
                                           child: Center(
                                             child: Text(
                                               category.name,
                                               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,  color:  selectedCategoryIndex == index ? CustomColor.whiteColor : CustomColor.blackColor),
                                             ),
                                           ),
                                           onTap: () {
                                             setState(() {
                                               if (selectedCategoryIndex == index) {
                                                 selectedCategoryIndex = -1;
                                                 isAllSelected = true;
                                               }
                                               else {
                                                 selectedCategoryIndex = index;
                                                 isAllSelected = false;
                                               }
                                             });
                                     
                                             print(category.id);
                                           },
                                         );
                                       }),
                                     )
                                       ],
                                     ),
                                   )
                                   : const SizedBox.shrink(),

                             ],
                           ),
                         ),
                       ),

                      if (_tabController.index == 0)
                        BlocBuilder<ProviderSubscribeBloc, ProviderSubscribeState>(
                          builder: (context, state) {

                            if (state is ProviderSubscribeLoading) {
                              return const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(child: CircularProgressIndicator()),
                                ),
                              );
                            }

                            if (state is ProviderSubscribeError) {
                              return SliverToBoxAdapter(
                                child: Center(child: Text(state.message)),
                              );
                            }

                            if (state is ProviderSubscribeLoaded) {

                              final services = state.services.data;
                              final filteredServices = isAllSelected
                                  ? services
                                  : services.where((item) =>
                              selectedCategoryIndex != -1 &&
                                  providerCategory[selectedCategoryIndex].id == item.category!.id
                              ).toList();

                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                      (context, index) {

                                    // final item = services[index];
                                        final item = filteredServices[index];

                                        final packages = item.serviceDetails?.packages ?? [];

                                    return CustomContainer(
                                      border: true,
                                      color: Colors.white,
                                      margin: const EdgeInsets.all(10),
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [

                                          CustomNetworkImage(
                                              borderRadius: BorderRadius.circular(10),
                                              height: dimensions.screenHeight*0.156,
                                              imageUrl: item.thumbnailImage,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                spacing: 10,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  CustomContainer(
                                                    margin: EdgeInsets.zero,
                                                   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                   color: Colors.green.shade500,
                                                    child: Text('Available', style: TextStyle(color: Colors.white,fontSize: 10),),),

                                                  FavoriteServiceButtonWidget(serviceId: item.id)
                                                ],
                                              ),
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              spacing: 10,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(item.serviceName, style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                                                    CustomContainer(
                                                      margin: EdgeInsets.zero,
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                      color: Color(0xFFF6F6F6),
                                                      child: Text('Earn Up To ${item.franchiseDetails!.commission}', style: TextStyle(color: Colors.black,fontSize: 10),),),

                                                  ],
                                                ),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    CustomContainer(
                                                      margin: EdgeInsets.zero,
                                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                                      color: Color(0xFFF6F6F6),
                                                      child: Text('${item.categoryName}', style: TextStyle(color: Colors.black,fontSize: 10),),),

                                                    Row(
                                                      spacing: 4,
                                                      children: List.generate(5, (index) {
                                                        final rating = item.averageRating; // e.g. 3.5

                                                        if (index < rating.floor()) {
                                                          // full star
                                                          return const Icon(
                                                            Icons.star,
                                                            size: 16,
                                                            color: Colors.amber,
                                                          );
                                                        } else if (index < rating && rating % 1 != 0) {
                                                          // half star
                                                          return const Icon(
                                                            Icons.star_half,
                                                            size: 16,
                                                            color: Colors.amber,
                                                          );
                                                        } else {
                                                          // empty star
                                                          return const Icon(
                                                            Icons.star_border,
                                                            size: 16,
                                                            color: Colors.amber,
                                                          );
                                                        }
                                                      }),
                                                    ),
                                                  ],
                                                ),


                                                if(packages.isNotEmpty)
                                                CustomContainer(
                                                  border: true,
                                                  color: Colors.white,
                                                  margin: EdgeInsets.zero,
                                                  child: Row(
                                                    spacing: 6,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text('Starting From',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                                      CustomAmountText(amount: item.serviceDetails!.packages.first.discountedPrice.toStringAsFixed(0),fontSize: 16,fontWeight: FontWeight.w600),
                                                      CustomAmountText(amount: item.serviceDetails!.packages.first.price.toStringAsFixed(0), fontSize: 12,color: Colors.grey.shade700,isLineThrough: true),
                                                      Text('${item.serviceDetails!.packages.first.discount.toStringAsFixed(0)}% OFF',style: TextStyle(fontSize: 12,color: Colors.red),),
                                                    ],
                                                  ),
                                                )

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        switch (item.category!.module) {
                                          case "68b2caf72ff3f8a31bf7bb8f":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => FranchiseServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822dfd5e8235364b35df1a2":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MarketingDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822dfbce8235364b35df19f":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => BusinessServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822dfd5e8235364b35df1a2":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => EducationServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822dfefe8235364b35df1a5":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => LegalServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822e003e8235364b35df1a8":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => FinanceServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822e075e8235364b35df1b4":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AiHubServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822e018e8235364b35df1ab":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => ItServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          case "6822e05ee8235364b35df1b1":
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => OnDemandServiceDetailsScreen(
                                                  serviceId: item.id,
                                                  serviceName: item.serviceName,
                                                ),
                                              ),
                                            );
                                            break;

                                          default:
                                            showCustomSnackBar(context,'Module not supported');
                                        }
                                      },
                                    );
                                  },
                                  childCount: filteredServices.length,
                                ),
                              );
                            }

                            return const SliverToBoxAdapter(child: SizedBox());
                          },
                        ),


                      if (_tabController.index == 1)
                         SliverToBoxAdapter(
                           child: ProviderReviewScreen(
                             providerId: provider.id.toString(),
                           ),
                         ),

                       if (_tabController.index == 2)
                         SliverToBoxAdapter(
                           child: Padding(
                             padding: const EdgeInsets.all(10),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('About Us', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                                 Text(provider.storeInfo?.aboutUs?.isEmpty ?? true
                                    ? 'N/A'
                                        : provider.storeInfo!.aboutUs!,
                                 style: TextStyle(color: Colors.grey.shade700),),
                                 20.height,

                                 Text('Details', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                                 // 10.height,
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text('Owner Name', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                                     Text('${provider.fullName}', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                                   ],
                                 ),

                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Row(
                                       spacing: 5,
                                       children: [
                                         Image.asset(CustomIcon.phoneIcon,height: 12,),
                                         Text('${provider.storeInfo!.storePhone}', style: TextStyle(fontSize: 12,color: Colors.grey.shade700)),
                                       ],
                                     ),
                                     Row(
                                       spacing: 5,
                                       children: [
                                         Icon(Icons.email_outlined,color: Colors.grey.shade700,size: 14,),
                                         Text('${provider.storeInfo!.storeEmail}', style: TextStyle(fontSize: 12,color: Colors.grey.shade700)),
                                       ],
                                     ),

                                   ],
                                 ),
                                 5.height,

                                 Row(
                                   // spacing: 5,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.all(2.0),
                                       child: Icon(Icons.location_on_outlined,color: Colors.grey.shade700,size: 14,),
                                     ),
                                     Expanded(child: Text('${provider.storeInfo!.address}', style: TextStyle(fontSize: 12,color: Colors.grey.shade700))),
                                   ],
                                 ),
                                 20.height,
                                 
                                 Text('Why customers choose us', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                                 5.height,
                                 Row(
                                   spacing: 10,
                                   children: [
                                     Icon(Icons.check,size: 14,color: Colors.grey.shade700,),
                                     Text('Background-verified professionals',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                                   ],
                                 ),
                                 Row(
                                   spacing: 10,
                                   children: [
                                     Icon(Icons.check,size: 14,color: Colors.grey.shade700,),
                                     Text('Brings own tools & supplies',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                                   ],
                                 ),
                                 Row(
                                   spacing: 10,
                                   children: [
                                     Icon(Icons.check,size: 14,color: Colors.grey.shade700,),
                                     Text('On-time, every time',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                                   ],
                                 ),

                               ],
                             ),
                           ),
                         ),

                       if (_tabController.index == 3)
                         SliverToBoxAdapter(
                           child: GalleryWidget(
                             providerId: provider.id.toString(),
                           ),
                         ),

                      SliverToBoxAdapter(child: SizedBox(height: 40,),),

                    ],
                   );
                 }
                 return SizedBox.shrink();
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileCard({ProviderModel? data, String? storeName}) {
    return CustomContainer(
      color: Colors.white,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding:  EdgeInsets.only(left: 15.0, top: 15, bottom: 10),
            child: Row(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: (data!.storeInfo!.logo != null &&
                            data.storeInfo!.logo.isNotEmpty &&
                            Uri.tryParse(data.storeInfo!.logo)?.hasAbsolutePath == true)
                            ? ClipOval(
                          child: Image.network(
                            data.storeInfo!.logo,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return  Icon(Icons.store, size: 30, color: Colors.grey,);
                            },
                          ),
                        ) :  Icon(Icons.store, size: 30, color: Colors.grey,),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.storeInfo!.storeName.toString(),style: textStyle12(context),),
                            Text(
                              '⭐ ${data.averageRating} (${data.totalReviews} Review)',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            if(data.storeInfo?.aboutUs != null)
                              Text('${data.storeInfo?.aboutUs
                              }', style: textStyle12(context,fontWeight: FontWeight.w400,color: Colors.grey.shade700),maxLines: 2,overflow: TextOverflow.ellipsis,),
                        
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color:data.isStoreOpen== true? CustomColor.greenColor:Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(data.isStoreOpen== true ?'Available':"Close", style: TextStyle(fontSize: 12, color: CustomColor.whiteColor),))
              ],
            ),
          ),

          // Positioned(
          //     top: 10,
          //     right: 10,
          //     child: FavoriteProviderButtonWidget(providerId: data.id.toString(),)
          // ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => 210;

  @override
  double get minExtent => 210;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

ImageProvider _getImageProvider(String? url) {
  if (url != null && url.isNotEmpty) {
    final uri = Uri.tryParse(url);
    if (uri != null && (uri.hasScheme && (uri.isScheme("http") || uri.isScheme("https")))) {
      return NetworkImage(url);
    }
  }
  return AssetImage(CustomImage.nullBackImage);
}