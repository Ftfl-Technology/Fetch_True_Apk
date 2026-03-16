import 'package:equatable/equatable.dart';
import '../../model/education_recommended_service_model.dart';

abstract class EducationRecommendedServiceState extends Equatable {
  const EducationRecommendedServiceState();

  @override
  List<Object> get props => [];
}

class EducationRecommendedServiceInitial
    extends EducationRecommendedServiceState {}

class EducationRecommendedServiceLoading
    extends EducationRecommendedServiceState {}

class EducationRecommendedServiceLoaded
    extends EducationRecommendedServiceState {
  final EducationRecommendedServiceModel data;

  const EducationRecommendedServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class EducationRecommendedServiceError
    extends EducationRecommendedServiceState {
  final String message;

  const EducationRecommendedServiceError(this.message);

  @override
  List<Object> get props => [message];
}
