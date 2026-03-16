import 'package:bloc/bloc.dart';
import '../../repository/education_top_trending_service_repository.dart';
import 'education_top_trending_service_event.dart';
import 'education_top_trending_service_state.dart';


class EducationTopTrendingServiceBloc extends Bloc<
    EducationTopTrendingServiceEvent,
    EducationTopTrendingServiceState> {
  final EducationTopTrendingServiceRepository repository;

  EducationTopTrendingServiceBloc(this.repository)
      : super(EducationTopTrendingServiceInitial()) {
    on<FetchEducationTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchEducationTopTrendingServices event,
      Emitter<EducationTopTrendingServiceState> emit,
      ) async {
    emit(EducationTopTrendingServiceLoading());
    try {
      final result = await repository.getEducationTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(EducationTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(EducationTopTrendingServiceError(e.toString()));
    }
  }
}
