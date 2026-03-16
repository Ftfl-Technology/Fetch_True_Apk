import 'package:equatable/equatable.dart';

abstract class AllCouponEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAllCoupons extends AllCouponEvent {}