import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/on_demand_popular_provider_repository.dart';
import '../../repository/on_demand_recommended_provider_repository.dart';
import '../../repository/on_demand_top_trending_provider_repository.dart';
import 'on_demand_top_trending_provider_event.dart';
import 'on_demand_top_trending_provider_state.dart';

class OnDemandTopTrendingProviderBloc
    extends Bloc<OnDemandTopTrendingProviderEvent, OnDemandTopTrendingProviderState> {
  final OnDemandTopTrendingProviderRepository repository;

  OnDemandTopTrendingProviderBloc(this.repository)
      : super(OnDemandTopTrendingProviderInitial()) {
    on<FetchOnDemandTopTrendingProviders>(_onFetchOnDemandTopTrendingProviders);
  }

  Future<void> _onFetchOnDemandTopTrendingProviders(
      FetchOnDemandTopTrendingProviders event,
      Emitter<OnDemandTopTrendingProviderState> emit,
      ) async {
    emit(OnDemandTopTrendingProviderLoading());

    try {
      final result = await repository.getOnDemandTopTrendingProviders(
        moduleId: event.moduleId,
        lat: event.lat,
        lng: event.lng,
      );

      emit(OnDemandTopTrendingProviderLoaded(result));
    } catch (e) {
      emit(OnDemandTopTrendingProviderError(e.toString()));
    }
  }
}
