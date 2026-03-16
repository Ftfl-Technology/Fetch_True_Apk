import 'package:equatable/equatable.dart';


abstract class FranchisePopularServiceEvent extends Equatable {
  const FranchisePopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchFranchisePopularServices extends FranchisePopularServiceEvent {
  final String moduleId;

  const FetchFranchisePopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
