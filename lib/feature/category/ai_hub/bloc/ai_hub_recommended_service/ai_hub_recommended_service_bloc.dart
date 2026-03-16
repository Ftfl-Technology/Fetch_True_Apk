import 'package:bloc/bloc.dart';
import '../../repository/ai_hub_recommended_service_repository.dart';
import 'ai_hub_recommended_service_event.dart';
import 'ai_hub_recommended_service_state.dart';

class AiHubRecommendedServiceBloc extends Bloc<
    AiHubRecommendedServiceEvent,
    AiHubRecommendedServiceState> {
  final AiHubRecommendedServiceRepository repository;

  AiHubRecommendedServiceBloc(this.repository)
      : super(AiHubRecommendedServiceInitial()) {
    on<FetchAiHubRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchAiHubRecommendedServices event,
      Emitter<AiHubRecommendedServiceState> emit,
      ) async {
    emit(AiHubRecommendedServiceLoading());
    try {
      final result = await repository.getAiHubRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(AiHubRecommendedServiceLoaded(result));
    } catch (e) {
      emit(AiHubRecommendedServiceError(e.toString()));
    }
  }
}
