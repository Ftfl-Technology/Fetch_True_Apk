
import 'package:equatable/equatable.dart';

import '../../model/checkout_model.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final CheckOutModel model;

  const CheckoutSuccess(this.model);

  @override
  List<Object?> get props => [model];
}

class CheckoutFailure extends CheckoutState {
  final String error;

  const CheckoutFailure(this.error);

  @override
  List<Object?> get props => [error];
}
