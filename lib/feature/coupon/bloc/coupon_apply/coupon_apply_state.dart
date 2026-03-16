import 'package:equatable/equatable.dart';
import '../../model/coupon_apply_model.dart';

abstract class CouponApplyState extends Equatable {
  const CouponApplyState();

  @override
  List<Object?> get props => [];
}

class CouponApplyInitial extends CouponApplyState {}

class CouponApplyLoading extends CouponApplyState {}

class CouponApplySuccess extends CouponApplyState {
  final CouponApplyResponse response;

  const CouponApplySuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class CouponApplyFailure extends CouponApplyState {
  final String error;

  const CouponApplyFailure(this.error);

  @override
  List<Object?> get props => [error];
}
