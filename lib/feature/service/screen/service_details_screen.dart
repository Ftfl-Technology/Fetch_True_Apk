// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:share_plus/share_plus.dart';
// import '../../../core/costants/custom_color.dart';
// import '../../../core/widgets/custom_appbar.dart';
// import '../../../core/widgets/custom_snackbar.dart';
// import '../../address/address_notifier.dart';
// import '../../auth/user_notifier/user_notifier.dart';
// import '../../checkout/screen/old_checkout_screen.dart';
// import '../../provider/bloc/provider/provider_bloc.dart';
// import '../../provider/bloc/provider/provider_event.dart';
// import '../../provider/bloc/provider/provider_state.dart';
// import '../../provider/repository/provider_repository.dart';
// import '../bloc/service/service_bloc.dart';
// import '../bloc/service/service_event.dart';
// import '../bloc/service/service_state.dart';
// import '../model/service_model.dart';
// import '../repository/service_repository.dart';
// import '../widget/franchise_details_section_widget.dart';
// import '../widget/service_banner_widget.dart';
// import '../widget/service_details_section_widget.dart';
// import '../widget/self_add_widget.dart';
//
// class ServiceDetailsScreen extends StatefulWidget {
//   final String serviceId;
//   final String providerId;
//   final bool isStore;
//   const ServiceDetailsScreen({
//     super.key,
//     required this.serviceId,
//     required this.providerId, required this.isStore,
//   });
//
//   @override
//   State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
// }
//
// class _ServiceDetailsScreenState extends State<ServiceDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   int _indexTap = 0;
//   List<ServiceModel> services = [];
//
//   @override
//   Widget build(BuildContext context) {
//
//     final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
//     final lat = addressNotifier.latitude;
//     final lng = addressNotifier.longitude;
//     if (lat == null || lng == null) {
//       return const Scaffold(
//         appBar: const CustomAppBar(title: 'Service Details', showBackButton: true, showSearchIcon: false,),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => ServiceBloc(ServiceRepository())..add(GetServices())),
//         BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders(lat, lng))),
//       ],
//       child: Scaffold(
//         appBar: CustomAppBar(
//           title: 'Service Details',
//           showBackButton: true,
//           showFavoriteIcon: true,
//         ),
//
//         body: BlocBuilder<ServiceBloc, ServiceState>(
//           builder: (context, state) {
//             if (state is ServiceLoading) {
//               return  LinearProgressIndicator(minHeight: 2.5, color: CustomColor.appColor,);
//             }
//
//             else if (state is ServiceLoaded) {
//               services = state.services
//                   .where((moduleService) => moduleService.id == widget.serviceId)
//                   .toList();
//
//               if (services.isEmpty) {
//                 return const Center(child: Text('No Service found.'));
//               }
//
//               return SafeArea(
//                 child: DefaultTabController(
//                   length: 2,
//                   child: CustomScrollView(
//                     slivers: [
//                       /// Banner
//                       SliverToBoxAdapter(
//                         child: ServiceBannerWidget(services: services),
//                       ),
//
//                       /// Sticky TabBar
//                       SliverPersistentHeader(
//                         pinned: true,
//                         floating: true,
//                         delegate: _StickyHeaderDelegate(
//                           child: SizedBox(
//                             height: 50,
//                             child: TabBar(
//                               tabs: const [
//                                 Tab(text: 'Service Details'),
//                                 Tab(text: 'Franchise Details'),
//                               ],
//                               dividerColor: Colors.transparent,
//                               indicatorColor: CustomColor.appColor,
//                               labelColor: Colors.black,
//                               onTap: (value) {
//                                 setState(() {
//                                   _indexTap = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SliverToBoxAdapter(child: SizedBox(height: 5)),
//
//                       /// Tab View
//                       // SliverToBoxAdapter(
//                       //   child: AnimatedSwitcher(
//                       //     duration: const Duration(milliseconds: 300),
//                       //     child: _indexTap == 0
//                       //         ? ServiceDetailsSectionWidget(services: services)
//                       //         : FranchiseDetailsSectionWidget(services: services),
//                       //   ),
//                       // ),
//                       const SliverToBoxAdapter(child: SizedBox(height: 50)),
//                     ],
//                   ),
//                 ),
//               );
//             }
//
//             else if (state is ServiceError) {
//               return Center(child: Text(state.message));
//             }
//
//             return const SizedBox.shrink();
//           },
//         ),
//
//         /// Bottom Buttons
//         bottomNavigationBar: BlocBuilder<ProviderBloc, ProviderState>(
//           builder: (context, providerState) {
//             return SafeArea(
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: CustomColor.appColor),
//                 ),
//                 child: Row(
//                   children: [
//                     /// Self Add Button
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           final serviceId = services.isNotEmpty ? services.first.id : null;
//                           if (serviceId == null) {
//                             showCustomToast('Please wait, data is loading.');
//                             return;
//                           }
//
//                           final providerId = widget.providerId;
//
//                           /// ✅ Condition Based Navigation
//                           /// - In Service Provider: direct checkout
//                           /// - Out Service Provider: bottom sheet (select provider)
//                           if (providerId.isNotEmpty) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => OldCheckoutScreen(
//                                   serviceId: serviceId,
//                                   providerId: providerId,
//                                   status: 'default',
//                                   isStore: widget.isStore,
//                                 ),
//                               ),
//                             );
//                           } else if (providerState is ProvidersLoaded) {
//                             showCustomBottomSheet(context, serviceId: serviceId, isStore: widget.isStore);
//                           } else {
//                             showCustomToast('Please wait data is loading.');
//                           }
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                              Icon(CupertinoIcons.person_crop_circle_badge_checkmark, color: CustomColor.appColor),
//                             const SizedBox(width: 6),
//                             Text(
//                               'Self Add',
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 14,
//                                   color: CustomColor.appColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//
//                     /// Share to Customer
//                     Expanded(
//                       child: Container(
//                         color: CustomColor.appColor,
//                         height: double.infinity,
//                         child: InkWell(
//                           onTap: () {
//                             final userSession = Provider.of<UserSession>(context, listen: false);
//                             final serviceId = widget.serviceId;
//                             final userId =
//                             services.isNotEmpty ? userSession.userId : null;
//
//                             if (userId != null) {
//                               final shareUrl =
//                                   'https://fetchtrue-service-page.vercel.app/?serviceId=$serviceId&userId=$userId';
//                               Share.share(
//                                   'Check out this service on FetchTrue:\n$shareUrl');
//                             } else {
//                               showCustomToast('Please wait data is loading.');
//                             }
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: const [
//                               Icon(Icons.share, color: Colors.white),
//                               SizedBox(width: 6),
//                               Text('Share To Customer',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                     color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// Sticky Header Delegate
// class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//   _StickyHeaderDelegate({required this.child});
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(color: Colors.white, child: child);
//   }
//
//   @override
//   double get maxExtent => 50;
//
//   @override
//   double get minExtent => 50;
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
//       true;
// }
