import 'package:bloc/bloc.dart';
import '../../repository/finance_top_trending_service_repository.dart';
import 'finance_top_trending_service_event.dart';
import 'finance_top_trending_service_state.dart';


class FinanceTopTrendingServiceBloc extends Bloc<
    FinanceTopTrendingServiceEvent,
    FinanceTopTrendingServiceState> {
  final FinanceTopTrendingServiceRepository repository;

  FinanceTopTrendingServiceBloc(this.repository)
      : super(FinanceTopTrendingServiceInitial()) {
    on<FetchFinanceTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFinanceTopTrendingServices event,
      Emitter<FinanceTopTrendingServiceState> emit,
      ) async {
    emit(FinanceTopTrendingServiceLoading());
    try {
      final result = await repository.getFinanceTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(FinanceTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(FinanceTopTrendingServiceError(e.toString()));
    }
  }
}
