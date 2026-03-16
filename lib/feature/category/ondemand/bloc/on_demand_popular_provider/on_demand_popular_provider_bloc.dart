import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/on_demand_popular_provider_repository.dart';
import 'on_demand_popular_provider_event.dart';
import 'on_demand_popular_provider_state.dart';

class OnDemandPopularProviderBloc
    extends Bloc<OnDemandPopularProviderEvent, OnDemandPopularProviderState> {
  final OnDemandPopularProviderRepository repository;

  OnDemandPopularProviderBloc(this.repository)
      : super(OnDemandPopularProviderInitial()) {
    on<FetchOnDemandPopularProviders>(_onFetchOnDemandPopularProviders);
  }

  Future<void> _onFetchOnDemandPopularProviders(
      FetchOnDemandPopularProviders event,
      Emitter<OnDemandPopularProviderState> emit,
      ) async {
    emit(OnDemandPopularProviderLoading());

    try {
      final result = await repository.getOnDemandPopularProviders(
        moduleId: event.moduleId,
        lat: event.lat,
        lng: event.lng,
      );

      emit(OnDemandPopularProviderLoaded(result));
    } catch (e) {
      emit(OnDemandPopularProviderError(e.toString()));
    }
  }
}
