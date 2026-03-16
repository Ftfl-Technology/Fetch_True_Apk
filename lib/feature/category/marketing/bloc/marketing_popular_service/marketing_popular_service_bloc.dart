import 'package:bloc/bloc.dart';
import '../../repository/marketing_popular_service_repository.dart';
import 'marketing_popular_service_event.dart';
import 'marketing_popular_service_state.dart';


class MarketingPopularServiceBloc extends Bloc<MarketingPopularServiceEvent, MarketingPopularServiceState> {
  final MarketingPopularServiceRepository repository;

  MarketingPopularServiceBloc(this.repository)
      : super(MarketingPopularServiceInitial()) {
    on<FetchMarketingPopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchMarketingPopularServices event,
      Emitter<MarketingPopularServiceState> emit,
      ) async {
    emit(MarketingPopularServiceLoading());
    try {
      final result = await repository.getMarketingPopularServices(
        moduleId: event.moduleId,
      );
      emit(MarketingPopularServiceLoaded(result));
    } catch (e) {
      emit(MarketingPopularServiceError(e.toString()));
    }
  }
}
