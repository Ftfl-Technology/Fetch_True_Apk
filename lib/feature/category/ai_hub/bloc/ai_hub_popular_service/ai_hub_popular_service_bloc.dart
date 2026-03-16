import 'package:bloc/bloc.dart';
import '../../repository/ai_hub_popular_service_repository.dart';
import 'ai_hub_popular_service_event.dart';
import 'ai_hub_popular_service_state.dart';


class AiHubPopularServiceBloc extends Bloc<
    AiHubPopularServiceEvent,
    AiHubPopularServiceState> {
  final AiHubPopularServiceRepository repository;

  AiHubPopularServiceBloc(this.repository)
      : super(AiHubPopularServiceInitial()) {
    on<FetchAiHubPopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchAiHubPopularServices event,
      Emitter<AiHubPopularServiceState> emit,
      ) async {
    emit(AiHubPopularServiceLoading());
    try {
      final result = await repository.getAiHubPopularServices(
        moduleId: event.moduleId,
      );
      emit(AiHubPopularServiceLoaded(result));
    } catch (e) {
      emit(AiHubPopularServiceError(e.toString()));
    }
  }
}
