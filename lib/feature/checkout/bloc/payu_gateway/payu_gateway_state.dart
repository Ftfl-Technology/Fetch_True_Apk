part of 'payu_gateway_bloc.dart';

abstract class PayUGatewayState extends Equatable {
  const PayUGatewayState();

  @override
  List<Object?> get props => [];
}

class PayUGatewayInitial extends PayUGatewayState {}

class PayUGatewayLoading extends PayUGatewayState {}

class PayUGatewaySuccess extends PayUGatewayState {
  final PayUGatewayResponseModel response;

  const PayUGatewaySuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class PayUGatewayFailure extends PayUGatewayState {
  final String message;

  const PayUGatewayFailure(this.message);

  @override
  List<Object?> get props => [message];
}
