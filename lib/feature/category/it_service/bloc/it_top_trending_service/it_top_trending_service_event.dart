import 'package:equatable/equatable.dart';


abstract class ItTopTrendingServiceEvent extends Equatable {
  const ItTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchItTopTrendingServices extends ItTopTrendingServiceEvent {
  final String moduleId;

  const FetchItTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
