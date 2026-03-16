abstract class UserByUserCouponEvent {}

class FetchUserByUserCoupons extends UserByUserCouponEvent {
  final String userId;

  FetchUserByUserCoupons(this.userId);
}