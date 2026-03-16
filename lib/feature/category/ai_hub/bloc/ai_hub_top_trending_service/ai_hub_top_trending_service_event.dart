import 'package:equatable/equatable.dart';


abstract class AiHubTopTrendingServiceEvent extends Equatable {
  const AiHubTopTrendingServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchAiHubTopTrendingServices extends AiHubTopTrendingServiceEvent {
  final String moduleId;

  const FetchAiHubTopTrendingServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
