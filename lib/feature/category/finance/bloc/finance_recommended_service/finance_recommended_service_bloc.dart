import 'package:bloc/bloc.dart';
import '../../repository/finance_recommended_service_repository.dart';
import 'finance_recommended_service_event.dart';
import 'finance_recommended_service_state.dart';


class FinanceRecommendedServiceBloc extends Bloc<
    FinanceRecommendedServiceEvent,
    FinanceRecommendedServiceState> {
  final FinanceRecommendedServiceRepository repository;

  FinanceRecommendedServiceBloc(this.repository)
      : super(FinanceRecommendedServiceInitial()) {
    on<FetchFinanceRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFinanceRecommendedServices event,
      Emitter<FinanceRecommendedServiceState> emit,
      ) async {
    emit(FinanceRecommendedServiceLoading());
    try {
      final result = await repository.getFinanceRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(FinanceRecommendedServiceLoaded(result));
    } catch (e) {
      emit(FinanceRecommendedServiceError(e.toString()));
    }
  }
}
