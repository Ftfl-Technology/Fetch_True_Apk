part of 'payu_gateway_bloc.dart';

abstract class PayUGatewayEvent extends Equatable {
  const PayUGatewayEvent();

  @override
  List<Object?> get props => [];
}

class CreatePayULinkEvent extends PayUGatewayEvent {
  final PayUGatewayModel model;

  const CreatePayULinkEvent(this.model);

  @override
  List<Object?> get props => [model];
}
