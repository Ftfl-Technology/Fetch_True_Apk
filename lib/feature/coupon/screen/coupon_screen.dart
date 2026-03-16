// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import '../../../core/costants/custom_color.dart';
// import '../../../core/costants/text_style.dart';
// import '../../address/address_notifier.dart';
// import '../bloc/coupon/coupon_bloc.dart';
// import '../bloc/coupon/coupon_event.dart';
// import '../bloc/coupon/coupon_state.dart';
// import '../repository/coupon_repository.dart';
// import '../model/coupon_model.dart';
//
// class CouponScreen extends StatefulWidget {
//   final String userId;
//   final String serviceId;
//   const CouponScreen({super.key, required this.userId, required this.serviceId});
//
//   @override
//   State<CouponScreen> createState() => _CouponScreenState();
// }
//
// class _CouponScreenState extends State<CouponScreen> {
//   CouponModel? appliedCoupon;
//
//   @override
//   Widget build(BuildContext context) {
//     final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
//     final lat = addressNotifier.latitude;
//     final lng = addressNotifier.longitude;
//
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.pop(context, appliedCoupon);
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF2F2F2),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0.5,
//           title: Text(
//             'Coupons',
//             style: textStyle16(context, color: CustomColor.appColor),
//           ),
//           leading: IconButton(
//             onPressed: () => Navigator.pop(context, appliedCoupon),
//             icon: Icon(Icons.arrow_back_ios, color: CustomColor.appColor, size: 20),
//           ),
//         ),
//         body: SafeArea(
//           child: MultiBlocProvider(
//             providers: [
//               BlocProvider(
//                 create: (context) => CouponBloc(CouponRepository())
//                   ..add(
//                     FetchCouponsEvent(
//                       userId: widget.userId,
//                       serviceId: widget.serviceId,
//                       lat: lat!,
//                       lng: lng!,
//                     ),
//                   ),
//               ),
//             ],
//             child: BlocBuilder<CouponBloc, CouponState>(
//               builder: (context, couponState) {
//                 if (couponState is CouponLoading) {
//                   return LinearProgressIndicator(
//                     minHeight: 2.5,
//                     backgroundColor: CustomColor.appColor,
//                     color: CustomColor.whiteColor,
//                   );
//                 } else if (couponState is CouponLoaded) {
//                   final coupons = couponState.coupons;
//
//                   if (coupons.isEmpty) {
//                     return const Center(child: Text("No coupons found."));
//                   }
//
//                   return SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: List.generate(
//                         coupons.length,
//                             (index) => _buildCouponCard(context, coupons[index], coupons),
//                       ),
//                     ),
//                   );
//                 } else if (couponState is CouponError) {
//                   return Center(child: Text(couponState.message));
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCouponCard(
//       BuildContext context,
//       CouponModel coupon,
//       List<CouponModel> coupons,
//       ) {
//     final isPercentage = coupon.discountAmountType == 'Percentage';
//     final isCurrentlySelected = appliedCoupon?.couponId == coupon.couponId;
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Coupon Type Title
//           Text(
//             coupon.couponType,
//             style: textStyle14(context, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 4),
//
//           // Discount Description
//           Text(
//             "You save an extra ${isPercentage ? '${coupon.amount}%' : '₹${coupon.amount}'} with this coupon.",
//             style: textStyle14(
//               context,
//               fontWeight: FontWeight.w400,
//               color: CustomColor.descriptionColor,
//             ),
//           ),
//           const SizedBox(height: 14),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Coupon Code Badge
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   "#${coupon.couponCode}",
//                   style: textStyle12(context, color: CustomColor.greenColor),
//                 ),
//               ),
//
//               // Apply / Applied Button
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     if (isCurrentlySelected) {
//                       appliedCoupon = null;
//                     } else {
//                       appliedCoupon = coupon;
//                     }
//                   });
//                 },
//                 borderRadius: BorderRadius.circular(20),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: isCurrentlySelected
//                           ? CustomColor.appColor
//                           : Colors.grey.shade300,
//                     ),
//                     borderRadius: BorderRadius.circular(20),
//                     color: isCurrentlySelected
//                         ? CustomColor.appColor.withOpacity(0.05)
//                         : Colors.transparent,
//                   ),
//                   child: Text(
//                     isCurrentlySelected ? "Applied ✓" : "Apply Coupon",
//                     style: textStyle12(
//                       context,
//                       color: isCurrentlySelected
//                           ? CustomColor.appColor
//                           : CustomColor.descriptionColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../address/address_notifier.dart';
import '../bloc/coupon/coupon_bloc.dart';
import '../bloc/coupon/coupon_event.dart';
import '../bloc/coupon/coupon_state.dart';
import '../bloc/user_by_user_coupon/user_by_user_coupon_bloc.dart';
import '../bloc/user_by_user_coupon/user_by_user_coupon_event.dart';
import '../bloc/user_by_user_coupon/user_by_user_coupon_state.dart';
import '../repository/coupon_repository.dart';
import '../repository/user_by_user_coupon_repository.dart';
import '../model/coupon_model.dart';

class CouponScreen extends StatefulWidget {
  final String userId;
  final String serviceId;
  const CouponScreen({super.key, required this.userId, required this.serviceId});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  CouponModel? appliedCoupon;

  @override
  Widget build(BuildContext context) {
    final addressNotifier = Provider.of<AddressNotifier>(context, listen: false);
    final lat = addressNotifier.latitude;
    final lng = addressNotifier.longitude;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, appliedCoupon);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: Text(
            'Coupons',
            style: textStyle16(context, color: CustomColor.appColor),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context, appliedCoupon),
            icon: Icon(Icons.arrow_back_ios, color: CustomColor.appColor, size: 20),
          ),
        ),
        body: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CouponBloc(CouponRepository())
                  ..add(
                    FetchCouponsEvent(
                      userId: widget.userId,
                      serviceId: widget.serviceId,
                      lat: lat!,
                      lng: lng!,
                    ),
                  ),
              ),
              BlocProvider(
                create: (context) => UserByUserCouponBloc(UserByUserCouponRepository())
                  ..add(FetchUserByUserCoupons(widget.userId)),
              ),
            ],
            child: BlocBuilder<CouponBloc, CouponState>(
              builder: (context, couponState) {
                return BlocBuilder<UserByUserCouponBloc, UserByUserCouponState>(
                  builder: (context, userState) {
                    if (couponState is CouponLoading || userState is UserByUserCouponLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (couponState is CouponError) {
                      return Center(child: Text(couponState.message));
                    }

                    if (userState is UserByUserCouponError) {
                      return Center(child: Text(userState.message));
                    }

                    if (couponState is CouponLoaded && userState is UserByUserCouponLoaded) {
                      final coupons = couponState.coupons;
                      final usedCouponIds =
                      userState.coupons.map((c) => c.couponId).toList();

                      if (coupons.isEmpty) {
                        return const Center(child: Text("No coupons found."));
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            coupons.length,
                                (index) => _buildCouponCard(coupons[index], usedCouponIds),
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponCard(CouponModel coupon, List<String> usedCouponIds) {
    final isPercentage = coupon.discountAmountType == 'Percentage';
    final isUsed = usedCouponIds.contains(coupon.couponId);
    final isCurrentlySelected = appliedCoupon?.couponId == coupon.couponId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coupon.couponType,
            style: textStyle14(context, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "You save an extra ${isPercentage ? '${coupon.amount}%' : '₹${coupon.amount}'} with this coupon.",
            style: textStyle14(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Coupon Code Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "#${coupon.couponCode}",
                  style: textStyle12(context, color: CustomColor.greenColor),
                ),
              ),

              // Apply / Applied Button
              InkWell(
                onTap: isUsed
                    ? null // cannot select used coupons
                    : () {
                  setState(() {
                    appliedCoupon = isCurrentlySelected ? null : coupon;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isUsed
                          ? CustomColor.appColor
                          : isCurrentlySelected
                          ? CustomColor.appColor
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: isUsed
                        ? CustomColor.appColor.withOpacity(0.05)
                        : isCurrentlySelected
                        ? CustomColor.appColor.withOpacity(0.05)
                        : Colors.transparent,
                  ),
                  child: Text(
                    isUsed
                        ? "Applied ✓"
                        : isCurrentlySelected
                        ? "Applied ✓"
                        : "Apply Coupon",
                    style: textStyle12(
                      context,
                      color: isUsed || isCurrentlySelected
                          ? CustomColor.appColor
                          : CustomColor.descriptionColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}