import 'package:equatable/equatable.dart';
import '../../model/service_wise_provider_subscriber_model.dart';

abstract class ServiceWiseProviderSubscriberState extends Equatable {
  const ServiceWiseProviderSubscriberState();

  @override
  List<Object?> get props => [];
}

class ServiceWiseProviderSubscriberInitial
    extends ServiceWiseProviderSubscriberState {}

class ServiceWiseProviderSubscriberLoading
    extends ServiceWiseProviderSubscriberState {}

class ServiceWiseProviderSubscriberLoaded
    extends ServiceWiseProviderSubscriberState {
  final List<ProviderSubscriberModel> providers;

  const ServiceWiseProviderSubscriberLoaded(this.providers);

  @override
  List<Object?> get props => [providers];
}

class ServiceWiseProviderSubscriberError
    extends ServiceWiseProviderSubscriberState {
  final String message;

  const ServiceWiseProviderSubscriberError(this.message);

  @override
  List<Object?> get props => [message];
}
