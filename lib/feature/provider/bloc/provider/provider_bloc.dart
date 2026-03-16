import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/provider_repository.dart';
import 'provider_event.dart';
import 'provider_state.dart';
class ProviderBloc extends Bloc<ProviderEvent, ProviderState> {
  final ProviderRepository repository;

  ProviderBloc(this.repository) : super(ProviderInitial()) {
    // Fetch all providers
    // on<GetProviders>((event, emit) async {
    //   emit(ProviderLoading());
    //   try {
    //     final provider = await repository.getProvider();
    //     emit(ProvidersLoaded(providers: provider)); // original list
    //   } catch (e) {
    //     emit(ProviderError(e.toString()));
    //   }
    // });

    on<GetProviders>((event, emit) async {
      emit(ProviderLoading());
      try {
        final provider = await repository.getProvider(
          lat: event.lat,
          lng: event.lng,
        );
        emit(ProvidersLoaded(providers: provider));
      } catch (e) {
        emit(ProviderError(e.toString()));
      }
    });


    // Fetch single provider by id
    on<GetProviderById>((event, emit) async {
      emit(ProviderLoading());
      try {
        final providerById = await repository.getProviderById(event.id);
        emit(ProviderLoaded(providerById!));
      } catch (e) {
        emit(ProviderError(e.toString()));
      }
    });

    // Filter providers
    on<FilterProvidersEvent>((event, emit) {
      if (state is ProvidersLoaded) {
        final currentState = state as ProvidersLoaded;
        emit(currentState.copyWith(selectedFilter: event.filter));
      }
    });
  }
}