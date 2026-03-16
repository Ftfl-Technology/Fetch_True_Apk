import 'package:equatable/equatable.dart';

abstract class OnDemandServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchOnDemandServiceDetails extends OnDemandServiceDetailsEvent {
  final String serviceId;

  FetchOnDemandServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
