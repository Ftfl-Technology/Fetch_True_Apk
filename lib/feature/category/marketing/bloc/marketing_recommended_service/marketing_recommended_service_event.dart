part of 'marketing_recommended_service_bloc.dart';

abstract class MarketingRecommendedServiceEvent extends Equatable {
  const MarketingRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchMarketingRecommendedServices
    extends MarketingRecommendedServiceEvent {
  final String moduleId;

  const FetchMarketingRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
