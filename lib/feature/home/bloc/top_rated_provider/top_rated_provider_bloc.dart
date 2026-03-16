import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/top_rated_provider_repository.dart';
import 'top_rated_provider_event.dart';
import 'top_rated_provider_state.dart';

class TopRatedProviderBloc
    extends Bloc<TopRatedProviderEvent, TopRatedProviderState> {

  final TopRatedProviderRepository repository;

  TopRatedProviderBloc(this.repository)
      : super(TopRatedProviderInitial()) {

    on<FetchTopRatedProviders>((event, emit) async {
      emit(TopRatedProviderLoading());

      try {
        final providers = await repository.getTopRatedProviders();
        emit(TopRatedProviderLoaded(providers));
      } catch (e) {
        emit(TopRatedProviderError(e.toString()));
      }
    });
  }
}
