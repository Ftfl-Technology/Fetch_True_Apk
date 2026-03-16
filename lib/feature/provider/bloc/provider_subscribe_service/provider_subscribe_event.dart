import 'package:equatable/equatable.dart';

abstract class ProviderSubscribeEvent extends Equatable {
  const ProviderSubscribeEvent();

  @override
  List<Object?> get props => [];
}

class FetchSubscribedServices extends ProviderSubscribeEvent {
  final String providerId;

  const FetchSubscribedServices(this.providerId);

  @override
  List<Object?> get props => [providerId];
}
