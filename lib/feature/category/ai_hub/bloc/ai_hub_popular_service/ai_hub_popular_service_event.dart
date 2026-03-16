import 'package:equatable/equatable.dart';

abstract class AiHubPopularServiceEvent extends Equatable {
  const AiHubPopularServiceEvent();

  @override
  List<Object> get props => [];
}

class FetchAiHubPopularServices extends AiHubPopularServiceEvent {
  final String moduleId;

  const FetchAiHubPopularServices(this.moduleId);

  @override
  List<Object> get props => [moduleId];
}
