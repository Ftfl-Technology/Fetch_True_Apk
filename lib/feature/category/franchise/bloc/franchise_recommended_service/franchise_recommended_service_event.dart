import 'package:equatable/equatable.dart';

abstract class FranchiseRecommendedServiceEvent extends Equatable {
  const FranchiseRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchFranchiseRecommendedServices
    extends FranchiseRecommendedServiceEvent {
  final String moduleId;

  const FetchFranchiseRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
