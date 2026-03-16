import 'package:equatable/equatable.dart';
import '../../model/all_coupon_model.dart';

abstract class AllCouponState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AllCouponInitial extends AllCouponState {}

class AllCouponLoading extends AllCouponState {}

class AllCouponLoaded extends AllCouponState {
  final AllCouponModel coupons;

  AllCouponLoaded(this.coupons);

  @override
  List<Object?> get props => [coupons];
}

class AllCouponError extends AllCouponState {
  final String message;

  AllCouponError(this.message);

  @override
  List<Object?> get props => [message];
}