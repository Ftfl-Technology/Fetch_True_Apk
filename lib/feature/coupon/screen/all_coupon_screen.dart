import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../bloc/all_coupon/all_coupon_bloc.dart';
import '../bloc/all_coupon/all_coupon_event.dart';
import '../bloc/all_coupon/all_coupon_state.dart';
import '../bloc/user_by_user_coupon/user_by_user_coupon_bloc.dart';
import '../bloc/user_by_user_coupon/user_by_user_coupon_event.dart';
import '../bloc/user_by_user_coupon/user_by_user_coupon_state.dart';
import '../repository/all_coupon_repository.dart';
import '../repository/user_by_user_coupon_repository.dart';

class AllCouponScreen extends StatelessWidget {
  final String userId;
  const AllCouponScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AllCouponBloc(repository: AllCouponRepository())
            ..add(FetchAllCoupons()),
        ),
        BlocProvider(
          create: (_) =>
          UserByUserCouponBloc(UserByUserCouponRepository())
            ..add(FetchUserByUserCoupons(userId)),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        appBar: CustomAppBar(
          title: 'Coupons',
          showBackButton: true,
        ),
        body: BlocBuilder<AllCouponBloc, AllCouponState>(
          builder: (context, allState) {
            return BlocBuilder<UserByUserCouponBloc, UserByUserCouponState>(
              builder: (context, userState) {
                // Show loading if either bloc is loading
                if (allState is AllCouponLoading ||
                    userState is UserByUserCouponLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Both loaded
                if (allState is AllCouponLoaded &&
                    userState is UserByUserCouponLoaded) {
                  final coupons = allState.coupons.data;
                  // Use correct field from UserByUserCoupon model
                  final appliedIds =
                  userState.coupons.map((c) => c.couponId).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      final coupon = coupons[index];
                      // Use correct field for coupon.id
                      return _CouponCard(
                        coupon: coupon,
                        appliedCouponIds: appliedIds,
                      );
                    },
                  );
                }

                // Handle errors
                if (allState is AllCouponError) {
                  return Center(child: Text(allState.message));
                }
                if (userState is UserByUserCouponError) {
                  return Center(child: Text(userState.message));
                }

                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}

class _CouponCard extends StatefulWidget {
  final dynamic coupon;
  final List<String> appliedCouponIds;

  const _CouponCard({required this.coupon, required this.appliedCouponIds});

  @override
  State<_CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<_CouponCard> {
  // Use coupon.id (from your CouponData model) instead of couponId
  bool get _applied => widget.appliedCouponIds.contains(widget.coupon.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.coupon.couponType ?? 'default',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You save an extra ${widget.coupon.amount}% with this coupon.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Coupon Code Badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '#${widget.coupon.couponCode}',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),

              // Applied / Apply Button
              Container(  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _applied
                        ? CustomColor.appColor
                        : Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: _applied
                      ? CustomColor.appColor.withOpacity(0.05)
                      : Colors.transparent,
                ),
                child: Text(
                  _applied ? 'Used ✓' : 'Not Used',
                  style: textStyle12(
                    context,
                    color: _applied
                        ? CustomColor.appColor
                        : CustomColor.descriptionColor,
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