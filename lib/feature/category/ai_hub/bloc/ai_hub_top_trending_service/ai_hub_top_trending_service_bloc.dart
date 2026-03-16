import 'package:bloc/bloc.dart';
import '../../repository/ai_hub_top_trending_service_repository.dart';
import 'ai_hub_top_trending_service_event.dart';
import 'ai_hub_top_trending_service_state.dart';

class AiHubTopTrendingServiceBloc extends Bloc<
    AiHubTopTrendingServiceEvent,
    AiHubTopTrendingServiceState> {
  final AiHubTopTrendingServiceRepository repository;

  AiHubTopTrendingServiceBloc(this.repository)
      : super(AiHubTopTrendingServiceInitial()) {
    on<FetchAiHubTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchAiHubTopTrendingServices event,
      Emitter<AiHubTopTrendingServiceState> emit,
      ) async {
    emit(AiHubTopTrendingServiceLoading());
    try {
      final result = await repository.getAiHubTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(AiHubTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(AiHubTopTrendingServiceError(e.toString()));
    }
  }
}
