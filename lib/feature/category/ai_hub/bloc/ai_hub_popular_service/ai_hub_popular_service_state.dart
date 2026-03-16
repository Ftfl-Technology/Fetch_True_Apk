import 'package:equatable/equatable.dart';

import '../../model/ai_hub_popular_service_model.dart';

abstract class AiHubPopularServiceState extends Equatable {
  const AiHubPopularServiceState();

  @override
  List<Object> get props => [];
}

class AiHubPopularServiceInitial
    extends AiHubPopularServiceState {}

class AiHubPopularServiceLoading
    extends AiHubPopularServiceState {}

class AiHubPopularServiceLoaded
    extends AiHubPopularServiceState {
  final AiHubPopularServiceModel data;

  const AiHubPopularServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AiHubPopularServiceError
    extends AiHubPopularServiceState {
  final String message;

  const AiHubPopularServiceError(this.message);

  @override
  List<Object> get props => [message];
}
