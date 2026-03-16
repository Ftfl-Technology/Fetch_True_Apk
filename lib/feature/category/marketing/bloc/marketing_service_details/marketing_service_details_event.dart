import 'package:equatable/equatable.dart';

abstract class MarketingServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMarketingServiceDetails extends MarketingServiceDetailsEvent {
  final String serviceId;

  FetchMarketingServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
