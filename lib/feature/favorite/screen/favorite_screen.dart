import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/favorite/widget/favorite_service_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/formate_price.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../address/address_notifier.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../category/ai_hub/screen/ai_hub_service_details_screen.dart';
import '../../category/business/screen/business_service_details_screen.dart';
import '../../category/education/screen/education_service_details_screen.dart';
import '../../category/finance/screen/finance_service_details_screen.dart';
import '../../category/franchise/screen/franchise_service_details_screen.dart';
import '../../category/it_service/screen/it_service_details_screen.dart';
import '../../category/legal_service/screen/legal_service_details_screen.dart';
import '../../category/marketing/screen/marketing_details_screen.dart';
import '../../category/ondemand/screen/on_demand_service_details_screen.dart';
import '../../home/widget/mostly_popular_service.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/model/module_model.dart';
import '../../module/repository/module_repository.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/model/user_model.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/repository/provider_repository.dart';
import '../../provider/screen/provider__details_screen.dart';
import '../../service/bloc/service/service_bloc.dart';
import '../../service/bloc/service/service_event.dart';
import '../../service/bloc/service/service_state.dart';
import '../../service/repository/service_repository.dart';
import '../widget/favorite_provider_button_widget.dart';


class FavoriteScreen extends StatelessWidget {
  final String? userId;
  final String status;
  const FavoriteScreen({super.key, this.userId, required this.status});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Wishlist', showBackButton: true,),
        body: const Center(child: NoUserSignWidget()),
      );
    }
    return BlocBuilder<UserBloc, UserState>(
      buildWhen: (previous, current) {
        return !(previous is UserLoaded && current is UserLoading);
      },
      builder: (context, userState) {
        if (userState is UserLoaded) {
          final user = userState.user;

          return DefaultTabController(
            length: 2, // 2 Tabs
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Favorite',
                showBackButton: false,

                leadingWidth: 0,

                leading: Hero(
                  tag: 'favoriteBarHero',
                  child: Material(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.red,
                      size: 24, // SAME as source
                    ),
                  ),
                ),
              ),


              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorColor: CustomColor.appColor,
                        labelColor: Colors.black,
                        tabs: [
                          Tab(text: "Services"),
                          Tab(text: "Providers"),
                        ],
                      ),
                    ),
                    10.height,
                    Expanded(
                      child: TabBarView(
                        children: [
                          FavoriteServiceWidget(user: user,),
                          FavoriteProviderWidget( user: user,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

        }
        else if (userState is UserError) {
          debugPrint("Error: ${userState.massage}");
        }
        return const SizedBox.shrink();
      },
    );

  }
}


/// Favorite service
class FavoriteServiceWidget extends StatefulWidget {
  final UserModel user;
  const FavoriteServiceWidget({super.key, required this.user,});

  @override
  State<FavoriteServiceWidget> createState() => _FavoriteServiceWidgetState();
}

class _FavoriteServiceWidgetState extends State<FavoriteServiceWidget> {
  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    String formatCommission(dynamic rawCommission, {bool half = false}) {
      if (rawCommission == null) return '0';

      final commissionStr = rawCommission.toString();

      // Extract numeric value
      final numericStr = commissionStr.replaceAll(RegExp(r'[^0-9.]'), '');
      final numeric = double.tryParse(numericStr) ?? 0;

      // Extract symbol (₹, %, etc.)
      final symbol = RegExp(r'[^\d.]').firstMatch(commissionStr)?.group(0) ?? '';

      final value = half ? (numeric / 2).round() : numeric.round();

      // Format with symbol
      if (symbol == '%') {
        return '$value%';
      } else {
        return '$symbol$value';
      }
    }

    return BlocProvider(
      create: (_) => ServiceBloc(ServiceRepository())..add(GetServices()),
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, serviceState) {
          if (serviceState is ServiceLoading) {
            return  Center(child: CircularProgressIndicator(color: CustomColor.appColor));
          } else if (serviceState is ServiceLoaded) {
            final allServices = serviceState.services;
            final favoriteServiceIds = widget.user.favoriteServices;
            /// Filter only favorite services
            final favoriteServices = allServices.where((service) => favoriteServiceIds.contains(service.id)).toList();

            if (favoriteServices.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(CustomImage.emptyCart, height: 80),
                  const Text('No Service')
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: favoriteServices.length,
              itemBuilder: (context, index) {
                final data = favoriteServices[index];

                return CustomContainer(
                  border: false,
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(top: 10),
                  gradient: LinearGradient(
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFD8E0F0).withOpacity(0.6),
                      ]),
                  onTap: () {
                    switch (data.category!.module) {
                      case "68b2caf72ff3f8a31bf7bb8f":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FranchiseServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822dfd5e8235364b35df1a2":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MarketingDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822dfbce8235364b35df19f":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BusinessServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822dfd5e8235364b35df1a2":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EducationServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822dfefe8235364b35df1a5":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LegalServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822e003e8235364b35df1a8":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FinanceServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822e075e8235364b35df1b4":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AiHubServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822e018e8235364b35df1ab":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ItServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      case "6822e05ee8235364b35df1b1":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OnDemandServiceDetailsScreen(
                              serviceId: data.id,
                              serviceName: data.serviceName,
                            ),
                          ),
                        );
                        break;

                      default:
                        showCustomToast('Module not supported');
                    }
                  },
                  child: Column(
                    children: [
                      CustomNetworkImage(
                        height: dimensions.screenHeight * 0.18,
                        margin: EdgeInsets.zero,
                        imageUrl: data.thumbnailImage,
                        fit: BoxFit.fill,
                        borderRadius: BorderRadius.circular(10),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomContainer(
                                color: Colors.white,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.all(5),
                                child: Icon(Icons.verified_user_outlined, size: 14,color: CustomColor.appColor,),),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FavoriteServiceButtonWidget(serviceId: data.id,),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          10.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.serviceName, style: TextStyle(fontWeight: FontWeight.w600),overflow: TextOverflow.clip, maxLines: 2,),
                                    CustomContainer(
                                      color: CustomColor.appColor,
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                      child: Text('Earn Up To ${data.franchiseDetails.commission}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.white),),),
                                  ],
                                ),
                              ),
                              Column(
                                spacing: 5,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    spacing: 4,
                                    children: List.generate(5, (index) {
                                      final rating = data.averageRating; // e.g. 3.5

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
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Icon(Icons.account_circle_outlined, size: 12,color: Colors.grey.shade600,),
                                      Text('${data.totalReviews}+ Reviews', style: TextStyle(fontSize: 10, color: Colors.grey.shade600),)
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      10.height,

                      if(['6822e02de8235364b35df1ae', '6822e075e8235364b35df1b4', '6822dfd5e8235364b35df1a2', '6822dfefe8235364b35df1a5', '6822e018e8235364b35df1ab','6822e05ee8235364b35df1b1'].contains(data.category.module))
                        CustomContainer(
                          color: Colors.white,
                          margin: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(data.keyValues.length, (index) {
                                  final keyValue = data.keyValues[index];
                                  return Row(
                                    spacing: 5,
                                    children: [
                                      if(keyValue.icon.isNotEmpty)
                                        Image.network(keyValue.icon.toString(), height: 10,),
                                      if(keyValue.key.isNotEmpty)
                                        Text(keyValue.key.toString(), style: TextStyle(fontSize: 10),),
                                      if(keyValue.value.isNotEmpty)
                                        Text(keyValue.value,style: TextStyle(fontSize: 10),),
                                    ],
                                  );
                                },),
                              ),

                              if(data.serviceDetails.packages.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomContainer(
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                        margin: EdgeInsets.zero,
                                        color: Colors.green.shade500,
                                        child: Text('${data.serviceDetails.packages.first.discount.toStringAsFixed(0)}% Off', style: TextStyle(fontSize: 10,color: Colors.white, fontWeight: FontWeight.w500),)),
                                    Row(
                                      spacing: 5,
                                      children: [
                                        CustomAmountText(amount: '${data.serviceDetails.packages.first.price.toStringAsFixed(0)}',color: Colors.grey.shade700,isLineThrough: true),
                                        CustomAmountText(amount: '${data.serviceDetails.packages.first.discountedPrice.toStringAsFixed(0)}',fontSize: 18,fontWeight: FontWeight.w500),
                                      ],
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),

                      if(['6822e003e8235364b35df1a8',].contains(data.category.module))
                        GridView.builder(
                          itemCount: data.keyValues.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              childAspectRatio: 1/0.25
                          ),
                          itemBuilder: (context, index) {
                            final list = data.keyValues[index];
                            return Row(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (isValidUrl(list.icon))
                                  Image.network(
                                    list.icon!,
                                    height: 18,
                                    errorBuilder: (_, __, ___) => const SizedBox(),
                                  ),


                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if ((list.key ?? '').trim().isNotEmpty)
                                      Text(
                                        list.key!,
                                        style: const TextStyle(fontSize: 12),
                                      ),

                                    if(list.value != null)
                                      Text(list.value, style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                  ],
                                )
                              ],
                            );
                          },),

                      if(['6822dfbce8235364b35df19f','68b2caf72ff3f8a31bf7bb8f'].contains(data.category.module))
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if(data.franchiseDetails.investmentRange.isNotEmpty)
                                _InfoColumn(title: 'Investment', value: '${data.franchiseDetails.investmentRange.first.range.toString()} ${data.franchiseDetails.investmentRange.first.parameters.toString()}'),
                              if(data.franchiseDetails.investmentRange.isNotEmpty)
                                Container(color: Colors.grey,width: 1,height: 35,),

                              if(data.franchiseDetails.monthlyEarnPotential.isNotEmpty)
                                _InfoColumn(title: 'Earnings', value: '${data.franchiseDetails.monthlyEarnPotential.first.range.toString()} ${data.franchiseDetails.monthlyEarnPotential.first.parameters.toString()}'),

                              if( data.serviceDetails.roi.isNotEmpty)
                                Container(color: Colors.grey,width: 1,height: 35,),

                              if( data.serviceDetails.roi.isNotEmpty)
                                _InfoColumn(title: 'ROI', value: data.serviceDetails.roi.first),

                              if(data.franchiseDetails.areaRequired.isNotEmpty)
                                Container(color: Colors.grey,width: 1,height: 35,),

                              if(data.franchiseDetails.areaRequired.isNotEmpty)
                                _InfoColumn(title: 'Area Required', value: data.franchiseDetails.areaRequired),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          } else if (serviceState is ServiceError) {
            print('Favarate service error ${serviceState.message}');
            return SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );  }
}


/// Favorite provider
class FavoriteProviderWidget extends StatefulWidget {
  final UserModel user;
  const FavoriteProviderWidget({super.key, required this.user,});

  @override
  State<FavoriteProviderWidget> createState() => _FavoriteProviderWidgetState();
}

class _FavoriteProviderWidgetState extends State<FavoriteProviderWidget> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;
    if (lat == null || lng == null) {
      return  Center(child: CircularProgressIndicator());
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders(lat, lng))),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProviderBloc, ProviderState>(listener: (context, state) {
            if (state is ProviderError) debugPrint('Provider Error: ${state.message}');
          },),

        ],
        child: Builder(
          builder: (context) {
            final providerState = context.watch<ProviderBloc>().state;

            if(providerState is ProviderLoading){
              return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
            }

            if(providerState is ProvidersLoaded){
             final favoriteProviderIds  = widget.user.favoriteProviders;
              final providers = providerState.providers.where((provider) => favoriteProviderIds.contains(provider.id)).toList();

              if (providers.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(CustomImage.emptyCart, height: 80),
                    const Text('No Provider')
                  ],
                );
              }

             return ListView.builder(
               itemCount: providers.length,
               scrollDirection: Axis.vertical,
               itemBuilder: (context, index) {

                 final data = providers[index];

                 return CustomContainer(
                   border: true,
                   color: Colors.white,
                   width: dimensions.screenHeight*0.4,
                   padding: EdgeInsets.zero,
                   child: Stack(
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             decoration: BoxDecoration(
                                 color: Color(0xFFF7FAFE),
                                 borderRadius: BorderRadius.only(
                                   topRight: Radius.circular(10),
                                   topLeft: Radius.circular(10),
                                 )
                             ),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Container(
                                   height: 25,
                                   margin: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.15),
                                   decoration: BoxDecoration(
                                       image: DecorationImage(image: AssetImage('assets/image/provider_module_headline.png'),fit: BoxFit.fill)
                                   ),
                                   child: Center(child: Text('${data.storeInfo!.module!.name}', style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),)),
                                 ),
                                 10.height,
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [

                                     Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: CircleAvatar(
                                         radius: 30,
                                         backgroundColor: Colors.grey.shade200,
                                         child: (data.storeInfo!.logo != null &&
                                             data.storeInfo!.logo.isNotEmpty &&
                                             Uri.tryParse(data.storeInfo!.logo)?.hasAbsolutePath == true)
                                             ? ClipOval(
                                           child: Image.network(
                                             data.storeInfo!.logo,
                                             width: 60,
                                             height: 60,
                                             fit: BoxFit.cover,
                                             errorBuilder: (_, __, ___) {
                                               return Icon(Icons.store, size: 30, color: Colors.grey,);
                                             },
                                           ),
                                         ) :  Icon(Icons.store, size: 30, color: Colors.grey,),
                                       ),
                                     ),



                                     /// Info
                                     Expanded(
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(data.storeInfo!.storeName,
                                             style: TextStyle(
                                               fontSize: 14,
                                               fontWeight: FontWeight.w600,
                                             ),
                                           ),
                                           const SizedBox(height: 4),
                                           Text(
                                             "we provide you the best kitchen service",
                                             style: TextStyle(
                                               fontSize: 12,
                                               color: Colors.grey.shade700,
                                             ),
                                           ),
                                           const SizedBox(height: 6),

                                           Row(
                                             children: [
                                               Expanded(child: _infoRow(Icons.call, data.storeInfo!.storePhone)),
                                               Expanded(child: _infoRow(Icons.email, data.storeInfo!.storeEmail)),
                                               20.width
                                             ],
                                           ),
                                           _infoRow(
                                             Icons.location_on, data.storeInfo!.address,
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),


                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Expanded(
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       const Text(
                                         "Services Category",
                                         style: TextStyle(fontSize: 12),
                                       ),
                                       10.height,
                                       if (data.subscribedServices.isNotEmpty) ...[

                                         Builder(
                                           builder: (context) {
                                             final seenCategoryIds = <String>{};
                                             final uniqueServices = data.subscribedServices.where((service) {
                                               final id = service.category?.id;
                                               if (id != null && !seenCategoryIds.contains(id)) {
                                                 seenCategoryIds.add(id);
                                                 return true;
                                               }
                                               return false;
                                             }).toList();

                                             // sirf 4 items show karna
                                             final limitedServices = uniqueServices.take(5).toList();

                                             final children = limitedServices.map((service) {
                                               return Container(
                                                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                 decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(6),
                                                   border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                                 ),
                                                 child: Text(
                                                   '${service.category?.name ?? 'Unknown'}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                                 ),
                                               );
                                             }).toList();


                                             if (uniqueServices.length > 5) {
                                               children.add(
                                                   Container(
                                                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                                     decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(6),
                                                       border: Border.all(color: Colors.grey.shade500,width: 0.3),
                                                     ),
                                                     child:  Text(
                                                       'etc',style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                                                     ),
                                                   ));
                                             }

                                             return Wrap(
                                               spacing: 10,
                                               runSpacing: 10,
                                               children: children,
                                             );
                                           },
                                         )
                                       ]
                                     ],
                                   ),
                                 ),
                                 const SizedBox(width: 8),
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                   decoration: BoxDecoration(
                                     color: data.isStoreOpen ? Colors.green : Colors.grey.shade200,
                                     borderRadius: BorderRadius.circular(20),
                                   ),
                                   child: Text(
                                     data.isStoreOpen ? "Available" : "Close",
                                     style: TextStyle(
                                       fontSize: 11,
                                       color: data.isStoreOpen
                                           ? Colors.white
                                           : Colors.grey.shade700,
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),

                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 10.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('About Service', style: TextStyle(fontSize: 12),),
                                 5.height,
                                 Column(
                                   children: [
                                     Row(
                                       children: [
                                         Icon(Icons.work_outline, size: 14),
                                         SizedBox(width: 4),
                                         Text("${data.storeInfo!.totalExperience} Years - Working Experience", style: TextStyle(fontSize: 12)),
                                       ],
                                     ),
                                     Row(
                                       children: [
                                         Icon(Icons.star, size: 14, color: Colors.orange),
                                         SizedBox(width: 4),
                                         Text("${data.averageRating} Rating", style: TextStyle(fontSize: 12)),
                                         SizedBox(width: 4),
                                         Text("- by ${data.totalReviews} reviewed",
                                             style: TextStyle(fontSize: 11, color: Colors.grey)),
                                       ],
                                     )
                                   ],
                                 ),
                               ],
                             ),
                           ),

                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 10.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Service Details', style: TextStyle(fontSize: 12),),
                                 5.height,
                                 Wrap(
                                   spacing: 16,
                                   runSpacing: 8,
                                   children: List.generate(data.storeInfo!.tags.length,  (index) {
                                     final tag = data.storeInfo!.tags[index];
                                     return _Detail(text: "${tag}");
                                   },),
                                 ),
                               ],
                             ),
                           ),
                           10.height,
                         ],
                       ),

                       Positioned(
                           top: 10,right: 10,
                           child: FavoriteProviderButtonWidget(providerId: data.id)),
                     ],
                   ),
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderDetailsScreen(
                       storeName: data.storeInfo!.storeName,
                       providerId: data.id,
                     ),));
                   },
                 );
               },);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );

  }
  static Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blue),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final String text;
  const _Detail({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style:  TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey.shade700)),
      ],
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const _InfoColumn({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style:  TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: CustomColor.business),
        ),
      ],
    );
  }
}

bool isValidUrl(String? url) {
  if (url == null) return false;
  final uri = Uri.tryParse(url);
  return uri != null && uri.hasAbsolutePath && (uri.scheme == 'http' || uri.scheme == 'https');
}