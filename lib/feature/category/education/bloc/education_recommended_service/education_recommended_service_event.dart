import 'package:equatable/equatable.dart';

abstract class EducationRecommendedServiceEvent extends Equatable {
  const EducationRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchEducationRecommendedServices
    extends EducationRecommendedServiceEvent {
  final String moduleId;

  const FetchEducationRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
