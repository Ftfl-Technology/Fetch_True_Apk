import 'package:equatable/equatable.dart';
import '../../model/business_recommended_service_model.dart';

abstract class BusinessRecommendedServiceState extends Equatable {
  const BusinessRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class BusinessRecommendedServiceInitial
    extends BusinessRecommendedServiceState {}

class BusinessRecommendedServiceLoading
    extends BusinessRecommendedServiceState {}

class BusinessRecommendedServiceLoaded
    extends BusinessRecommendedServiceState {
  final BusinessRecommendedServiceModel data;

  const BusinessRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class BusinessRecommendedServiceError
    extends BusinessRecommendedServiceState {
  final String message;

  const BusinessRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
