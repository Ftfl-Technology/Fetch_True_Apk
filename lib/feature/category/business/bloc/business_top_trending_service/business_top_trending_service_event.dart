import 'package:equatable/equatable.dart';


abstract class BusinessTopTrendingServiceEvent extends Equatable {
  const BusinessTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessTopTrendingServices extends BusinessTopTrendingServiceEvent {
  final String moduleId;

  const FetchBusinessTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
