import 'package:equatable/equatable.dart';

abstract class ServiceWiseProviderSubscriberEvent extends Equatable {
  const ServiceWiseProviderSubscriberEvent();

  @override
  List<Object?> get props => [];
}

class FetchServiceWiseProviderSubscriber
    extends ServiceWiseProviderSubscriberEvent {
  final String serviceId;

  const FetchServiceWiseProviderSubscriber(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
