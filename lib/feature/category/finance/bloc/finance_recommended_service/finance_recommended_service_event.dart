import 'package:equatable/equatable.dart';

abstract class FinanceRecommendedServiceEvent extends Equatable {
  const FinanceRecommendedServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchFinanceRecommendedServices
    extends FinanceRecommendedServiceEvent {
  final String moduleId;

  const FetchFinanceRecommendedServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
