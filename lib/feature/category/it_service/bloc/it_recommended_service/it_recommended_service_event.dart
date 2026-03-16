import 'package:equatable/equatable.dart';

abstract class ItRecommendedServiceEvent extends Equatable {
  const ItRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchItRecommendedServices
    extends ItRecommendedServiceEvent {
  final String moduleId;

  const FetchItRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
