import 'package:equatable/equatable.dart';


abstract class FinanceTopTrendingServiceEvent extends Equatable {
  const FinanceTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchFinanceTopTrendingServices extends FinanceTopTrendingServiceEvent {
  final String moduleId;

  const FetchFinanceTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
