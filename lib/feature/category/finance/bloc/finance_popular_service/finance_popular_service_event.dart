import 'package:equatable/equatable.dart';


abstract class FinancePopularServiceEvent extends Equatable {
  const FinancePopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchFinancePopularServices extends FinancePopularServiceEvent {
  final String moduleId;

  const FetchFinancePopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
