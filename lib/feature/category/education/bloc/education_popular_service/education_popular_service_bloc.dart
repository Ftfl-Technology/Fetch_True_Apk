import 'package:bloc/bloc.dart';
import '../../repository/education_popular_service_repository.dart';
import 'education_popular_service_event.dart';
import 'education_popular_service_state.dart';



class EducationPopularServiceBloc extends Bloc<
    EducationPopularServiceEvent,
    EducationPopularServiceState> {
  final EducationPopularServiceRepository repository;

  EducationPopularServiceBloc(this.repository)
      : super(EducationPopularServiceInitial()) {
    on<FetchEducationPopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchEducationPopularServices event,
      Emitter<EducationPopularServiceState> emit,
      ) async {
    emit(EducationPopularServiceLoading());
    try {
      final result = await repository.getEducationPopularServices(
        moduleId: event.moduleId,
      );
      emit(EducationPopularServiceLoaded(result));
    } catch (e) {
      emit(EducationPopularServiceError(e.toString()));
    }
  }
}
