import 'package:equatable/equatable.dart';

import '../../model/provider_subscribe_service_model.dart';

abstract class ProviderSubscribeState extends Equatable {
  const ProviderSubscribeState();

  @override
  List<Object?> get props => [];
}

class ProviderSubscribeInitial extends ProviderSubscribeState {}

class ProviderSubscribeLoading extends ProviderSubscribeState {}

class ProviderSubscribeLoaded extends ProviderSubscribeState {
  final ProviderSubscribeServiceModel services;

  const ProviderSubscribeLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ProviderSubscribeError extends ProviderSubscribeState {
  final String message;

  const ProviderSubscribeError(this.message);

  @override
  List<Object?> get props => [message];
}
