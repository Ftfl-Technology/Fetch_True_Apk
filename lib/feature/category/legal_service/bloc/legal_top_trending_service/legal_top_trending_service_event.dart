import 'package:equatable/equatable.dart';


abstract class LegalTopTrendingServiceEvent extends Equatable {
  const LegalTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchLegalTopTrendingServices extends LegalTopTrendingServiceEvent {
  final String moduleId;

  const FetchLegalTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
