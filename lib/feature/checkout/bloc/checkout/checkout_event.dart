
import 'package:equatable/equatable.dart';
import '../../model/checkout_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutRequestEvent extends CheckoutEvent {
  final CheckOutModel model;

  const CheckoutRequestEvent(this.model);

  @override
  List<Object?> get props => [model];
}
