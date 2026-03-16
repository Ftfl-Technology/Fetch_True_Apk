import 'package:bloc/bloc.dart';
import '../../repository/finance_popular_service_repository.dart';
import 'finance_popular_service_event.dart';
import 'finance_popular_service_state.dart';

class FinancePopularServiceBloc extends Bloc<
    FinancePopularServiceEvent,
    FinancePopularServiceState> {
  final FinancePopularServiceRepository repository;

  FinancePopularServiceBloc(this.repository)
      : super(FinancePopularServiceInitial()) {
    on<FetchFinancePopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFinancePopularServices event,
      Emitter<FinancePopularServiceState> emit,
      ) async {
    emit(FinancePopularServiceLoading());
    try {
      final result = await repository.getFinancePopularServices(
        moduleId: event.moduleId,
      );
      emit(FinancePopularServiceLoaded(result));
    } catch (e) {
      emit(FinancePopularServiceError(e.toString()));
    }
  }
}
