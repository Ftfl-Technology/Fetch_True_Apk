import 'package:bloc/bloc.dart';
import '../../repository/it_top_trending_service_repository.dart';
import 'it_top_trending_service_event.dart';
import 'it_top_trending_service_state.dart';


class ItTopTrendingServiceBloc extends Bloc<
    ItTopTrendingServiceEvent,
    ItTopTrendingServiceState> {
  final ItTopTrendingServiceRepository repository;

  ItTopTrendingServiceBloc(this.repository)
      : super(ItTopTrendingServiceInitial()) {
    on<FetchItTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchItTopTrendingServices event,
      Emitter<ItTopTrendingServiceState> emit,
      ) async {
    emit(ItTopTrendingServiceLoading());
    try {
      final result = await repository.getItTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(ItTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(ItTopTrendingServiceError(e.toString()));
    }
  }
}
