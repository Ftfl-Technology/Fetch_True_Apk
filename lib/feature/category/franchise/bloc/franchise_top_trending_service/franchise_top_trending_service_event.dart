import 'package:equatable/equatable.dart';


abstract class FranchiseTopTrendingServiceEvent extends Equatable {
  const FranchiseTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchFranchiseTopTrendingServices extends FranchiseTopTrendingServiceEvent {
  final String moduleId;

  const FetchFranchiseTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
