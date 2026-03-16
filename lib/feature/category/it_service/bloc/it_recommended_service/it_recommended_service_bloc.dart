import 'package:bloc/bloc.dart';
import '../../repository/it_recommended_service_repository.dart';
import 'it_recommended_service_event.dart';
import 'it_recommended_service_state.dart';

class ItRecommendedServiceBloc extends Bloc<
    ItRecommendedServiceEvent,
    ItRecommendedServiceState> {
  final ItRecommendedServiceRepository repository;

   ItRecommendedServiceBloc(this.repository)
      : super(ItRecommendedServiceInitial()) {
    on<FetchItRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchItRecommendedServices event,
      Emitter<ItRecommendedServiceState> emit,
      ) async {
    emit(ItRecommendedServiceLoading());
    try {
      final result = await repository.getItRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(ItRecommendedServiceLoaded(result));
    } catch (e) {
      emit(ItRecommendedServiceError(e.toString()));
    }
  }
}
