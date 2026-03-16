import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/marketing_recommended_service_model.dart';
import '../../repository/marketing_recommended_service_repository.dart';
part 'marketing_recommended_service_event.dart';
part 'marketing_recommended_service_state.dart';

class MarketingRecommendedServiceBloc extends Bloc<
    MarketingRecommendedServiceEvent,
    MarketingRecommendedServiceState> {
  final MarketingRecommendedServiceRepository repository;

  MarketingRecommendedServiceBloc(this.repository)
      : super(MarketingRecommendedServiceInitial()) {
    on<FetchMarketingRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchMarketingRecommendedServices event,
      Emitter<MarketingRecommendedServiceState> emit,
      ) async {
    emit(MarketingRecommendedServiceLoading());
    try {
      final result = await repository.getMarketingRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(MarketingRecommendedServiceLoaded(result));
    } catch (e) {
      emit(MarketingRecommendedServiceError(e.toString()));
    }
  }
}
