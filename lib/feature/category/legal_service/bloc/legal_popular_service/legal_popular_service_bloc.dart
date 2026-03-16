import 'package:bloc/bloc.dart';
import '../../repository/legal_popular_service_repository.dart';
import 'legal_popular_service_event.dart';
import 'legal_popular_service_state.dart';


class LegalPopularServiceBloc extends Bloc<
    LegalPopularServiceEvent,
    LegalPopularServiceState> {
  final LegalPopularServiceRepository repository;

  LegalPopularServiceBloc(this.repository)
      : super(LegalPopularServiceInitial()) {
    on<FetchLegalPopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchLegalPopularServices event,
      Emitter<LegalPopularServiceState> emit,
      ) async {
    emit(LegalPopularServiceLoading());
    try {
      final result = await repository.getLegalPopularServices(
        moduleId: event.moduleId,
      );
      emit(LegalPopularServiceLoaded(result));
    } catch (e) {
      emit(LegalPopularServiceError(e.toString()));
    }
  }
}
