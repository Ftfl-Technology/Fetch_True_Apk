import 'package:equatable/equatable.dart';

import '../../model/package_buy_payment_response_model.dart';

abstract class PackagePaymentState extends Equatable {
  const PackagePaymentState();

  @override
  List<Object?> get props => [];
}

class PackagePaymentInitial extends PackagePaymentState {}

class PackagePaymentLoading extends PackagePaymentState {}

class PackagePaymentSuccess extends PackagePaymentState {
  final PackageBuyPaymentResponseModel response;

  const PackagePaymentSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PackagePaymentFailure extends PackagePaymentState {
  final String error;

  const PackagePaymentFailure(this.error);

  @override
  List<Object?> get props => [error];
}
