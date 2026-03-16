import 'package:bloc/bloc.dart';
import '../../repository/it_popular_service_repository.dart';
import 'it_popular_service_event.dart';
import 'it_popular_service_state.dart';

class ItPopularServiceBloc extends Bloc<
    ItPopularServiceEvent,
    ItPopularServiceState> {
  final ItPopularServiceRepository repository;

  ItPopularServiceBloc(this.repository)
      : super(ItPopularServiceInitial()) {
    on<FetchItPopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchItPopularServices event,
      Emitter<ItPopularServiceState> emit,
      ) async {
    emit(ItPopularServiceLoading());
    try {
      final result = await repository.getItPopularServices(
        moduleId: event.moduleId,
      );
      emit(ItPopularServiceLoaded(result));
    } catch (e) {
      emit(ItPopularServiceError(e.toString()));
    }
  }
}
