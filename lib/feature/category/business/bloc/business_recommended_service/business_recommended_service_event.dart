import 'package:equatable/equatable.dart';

abstract class BusinessRecommendedServiceEvent extends Equatable {
  const BusinessRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessRecommendedServices
    extends BusinessRecommendedServiceEvent {
  final String moduleId;

  const FetchBusinessRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
