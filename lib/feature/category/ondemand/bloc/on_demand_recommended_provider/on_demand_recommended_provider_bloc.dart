import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/on_demand_popular_provider_repository.dart';
import '../../repository/on_demand_recommended_provider_repository.dart';
import 'on_demand_recommended_provider_event.dart';
import 'on_demand_recommended_provider_state.dart';

class OnDemandRecommendedProviderBloc
    extends Bloc<OnDemandRecommendedProviderEvent, OnDemandRecommendedProviderState> {
  final OnDemandRecommendedProviderRepository repository;

  OnDemandRecommendedProviderBloc(this.repository)
      : super(OnDemandRecommendedProviderInitial()) {
    on<FetchOnDemandRecommendedProviders>(_onFetchOnDemandRecommendedProviders);
  }

  Future<void> _onFetchOnDemandRecommendedProviders(
      FetchOnDemandRecommendedProviders event,
      Emitter<OnDemandRecommendedProviderState> emit,
      ) async {
    emit(OnDemandRecommendedProviderLoading());

    try {
      final result = await repository.getOnDemandRecommendedProviders(
        moduleId: event.moduleId,
        lat: event.lat,
        lng: event.lng,
      );

      emit(OnDemandRecommendedProviderLoaded(result));
    } catch (e) {
      emit(OnDemandRecommendedProviderError(e.toString()));
    }
  }
}
