import 'package:equatable/equatable.dart';
import '../../model/legal_recommended_service_model.dart';

abstract class LegalRecommendedServiceState extends Equatable {
  const LegalRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class LegalRecommendedServiceInitial
    extends LegalRecommendedServiceState {}

class LegalRecommendedServiceLoading
    extends LegalRecommendedServiceState {}

class LegalRecommendedServiceLoaded
    extends LegalRecommendedServiceState {
  final LegalRecommendedServiceModel data;

  const LegalRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class LegalRecommendedServiceError
    extends LegalRecommendedServiceState {
  final String message;

  const LegalRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
