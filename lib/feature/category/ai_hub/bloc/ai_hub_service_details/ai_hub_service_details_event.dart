import 'package:equatable/equatable.dart';

abstract class AiHubServiceDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAiHubServiceDetails extends AiHubServiceDetailsEvent {
  final String serviceId;

  FetchAiHubServiceDetails(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}
