import 'package:bloc/bloc.dart';
import '../../repository/legal_recommended_service_repository.dart';
import 'legal_recommended_service_event.dart';
import 'legal_recommended_service_state.dart';


class LegalRecommendedServiceBloc extends Bloc<
    LegalRecommendedServiceEvent,
    LegalRecommendedServiceState> {
  final LegalRecommendedServiceRepository repository;

  LegalRecommendedServiceBloc(this.repository)
      : super(LegalRecommendedServiceInitial()) {
    on<FetchLegalRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchLegalRecommendedServices event,
      Emitter<LegalRecommendedServiceState> emit,
      ) async {
    emit(LegalRecommendedServiceLoading());
    try {
      final result = await repository.getLegalRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(LegalRecommendedServiceLoaded(result));
    } catch (e) {
      emit(LegalRecommendedServiceError(e.toString()));
    }
  }
}
