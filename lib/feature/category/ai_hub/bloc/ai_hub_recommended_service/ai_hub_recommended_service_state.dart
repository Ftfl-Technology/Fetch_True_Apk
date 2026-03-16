import 'package:equatable/equatable.dart';
import '../../model/ai_hub_recommended_service_model.dart';

abstract class AiHubRecommendedServiceState extends Equatable {
  const AiHubRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class AiHubRecommendedServiceInitial
    extends AiHubRecommendedServiceState {}

class AiHubRecommendedServiceLoading
    extends AiHubRecommendedServiceState {}

class AiHubRecommendedServiceLoaded
    extends AiHubRecommendedServiceState {
  final AiHubRecommendedServiceModel data;

  const AiHubRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AiHubRecommendedServiceError
    extends AiHubRecommendedServiceState {
  final String message;

  const AiHubRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
