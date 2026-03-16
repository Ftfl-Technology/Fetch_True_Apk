import 'package:bloc/bloc.dart';
import '../../repository/marketing_top_trending_service_repository.dart';
import 'marketing_top_trending_service_event.dart';
import 'marketing_top_trending_service_state.dart';



class MarketingTopTrendingServiceBloc extends Bloc<
    MarketingTopTrendingServiceEvent,
    MarketingTopTrendingServiceState> {
  final MarketingTopTrendingServiceRepository repository;

  MarketingTopTrendingServiceBloc(this.repository)
      : super(MarketingTopTrendingServiceInitial()) {
    on<FetchMarketingTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchMarketingTopTrendingServices event,
      Emitter<MarketingTopTrendingServiceState> emit,
      ) async {
    emit(MarketingTopTrendingServiceLoading());
    try {
      final result = await repository.getMarketingTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(MarketingTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(MarketingTopTrendingServiceError(e.toString()));
    }
  }
}
