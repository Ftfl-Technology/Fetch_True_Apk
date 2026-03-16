import 'package:bloc/bloc.dart';
import '../../repository/legal_top_trending_service_repository.dart';
import 'legal_top_trending_service_event.dart';
import 'legal_top_trending_service_state.dart';


class LegalTopTrendingServiceBloc extends Bloc<
    LegalTopTrendingServiceEvent,
    LegalTopTrendingServiceState> {
  final LegalTopTrendingServiceRepository repository;

  LegalTopTrendingServiceBloc(this.repository)
      : super(LegalTopTrendingServiceInitial()) {
    on<FetchLegalTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchLegalTopTrendingServices event,
      Emitter<LegalTopTrendingServiceState> emit,
      ) async {
    emit(LegalTopTrendingServiceLoading());
    try {
      final result = await repository.getLegalTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(LegalTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(LegalTopTrendingServiceError(e.toString()));
    }
  }
}
