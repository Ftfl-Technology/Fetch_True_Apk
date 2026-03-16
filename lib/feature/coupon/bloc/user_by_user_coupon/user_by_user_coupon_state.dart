
import '../../model/used_by_user_coupon.dart';

abstract class UserByUserCouponState {}

class UserByUserCouponInitial extends UserByUserCouponState {}

class UserByUserCouponLoading extends UserByUserCouponState {}

class UserByUserCouponLoaded extends UserByUserCouponState {
  final List<UsedByUserCoupon> coupons;

  UserByUserCouponLoaded(this.coupons);
}

class UserByUserCouponError extends UserByUserCouponState {
  final String message;

  UserByUserCouponError(this.message);
}