part of 'marketing_recommended_service_bloc.dart';

abstract class MarketingRecommendedServiceState extends Equatable {
  const MarketingRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class MarketingRecommendedServiceInitial
    extends MarketingRecommendedServiceState {}

class MarketingRecommendedServiceLoading
    extends MarketingRecommendedServiceState {}

class MarketingRecommendedServiceLoaded
    extends MarketingRecommendedServiceState {
  final MarketingRecommendedServiceModel data;

  const MarketingRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class MarketingRecommendedServiceError
    extends MarketingRecommendedServiceState {
  final String message;

  const MarketingRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
