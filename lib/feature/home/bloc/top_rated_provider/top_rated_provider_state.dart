
import '../../model/top_rated_provider_model.dart';

abstract class TopRatedProviderState {}

class TopRatedProviderInitial extends TopRatedProviderState {}

class TopRatedProviderLoading extends TopRatedProviderState {}

class TopRatedProviderLoaded extends TopRatedProviderState {
  final List<TopRatedProviderModel> providers;

  TopRatedProviderLoaded(this.providers);
}

class TopRatedProviderError extends TopRatedProviderState {
  final String message;

  TopRatedProviderError(this.message);
}
