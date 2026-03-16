import 'package:bloc/bloc.dart';
import '../../repository/education_recommended_service_repository.dart';
import 'education_recommended_service_event.dart';
import 'education_recommended_service_state.dart';


class EducationRecommendedServiceBloc extends Bloc<
    EducationRecommendedServiceEvent,
    EducationRecommendedServiceState> {
  final EducationRecommendedServiceRepository repository;

  EducationRecommendedServiceBloc(this.repository)
      : super(EducationRecommendedServiceInitial()) {
    on<FetchEducationRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchEducationRecommendedServices event,
      Emitter<EducationRecommendedServiceState> emit,
      ) async {
    emit(EducationRecommendedServiceLoading());
    try {
      final result = await repository.getEducationRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(EducationRecommendedServiceLoaded(result));
    } catch (e) {
      emit(EducationRecommendedServiceError(e.toString()));
    }
  }
}
