import 'package:equatable/equatable.dart';

abstract class AiHubRecommendedServiceEvent extends Equatable {
  const AiHubRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchAiHubRecommendedServices
    extends AiHubRecommendedServiceEvent {
  final String moduleId;

  const FetchAiHubRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
