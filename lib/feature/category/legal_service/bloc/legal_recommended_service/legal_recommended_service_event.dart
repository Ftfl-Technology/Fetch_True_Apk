import 'package:equatable/equatable.dart';

abstract class LegalRecommendedServiceEvent extends Equatable {
  const  LegalRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchLegalRecommendedServices
    extends LegalRecommendedServiceEvent {
  final String moduleId;

  const FetchLegalRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
