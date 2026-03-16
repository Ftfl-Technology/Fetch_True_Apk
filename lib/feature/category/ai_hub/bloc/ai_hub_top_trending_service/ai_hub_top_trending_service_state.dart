import 'package:equatable/equatable.dart';
import '../../model/ai_hub_top_trending_service_model.dart';


abstract class AiHubTopTrendingServiceState extends Equatable {
  const AiHubTopTrendingServiceState();

  @override
  List<Object> get props => [];
}

class AiHubTopTrendingServiceInitial
    extends AiHubTopTrendingServiceState {}

class AiHubTopTrendingServiceLoading
    extends AiHubTopTrendingServiceState {}

class AiHubTopTrendingServiceLoaded
    extends AiHubTopTrendingServiceState {
  final AiHubTopTrendingServiceModel data;

  const AiHubTopTrendingServiceLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AiHubTopTrendingServiceError
    extends AiHubTopTrendingServiceState {
  final String message;

  const AiHubTopTrendingServiceError(this.message);

  @override
  List<Object> get props => [message];
}
