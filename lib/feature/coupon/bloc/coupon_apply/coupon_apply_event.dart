import 'package:equatable/equatable.dart';
import '../../model/coupon_apply_model.dart';

abstract class CouponApplyEvent extends Equatable {
  const CouponApplyEvent();

  @override
  List<Object?> get props => [];
}

class ApplyCouponEvent extends CouponApplyEvent {
  final CouponApplyModel couponModel;

  const ApplyCouponEvent(this.couponModel);

  @override
  List<Object?> get props => [couponModel];
}
