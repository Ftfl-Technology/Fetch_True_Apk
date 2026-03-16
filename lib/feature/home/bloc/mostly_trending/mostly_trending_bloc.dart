import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/mostly_trending_repository.dart';
import 'mostly_trending_event.dart';
import 'mostly_trending_state.dart';

class MostlyTrendingBloc
    extends Bloc<MostlyTrendingEvent, MostlyTrendingState> {

  final MostlyTrendingRepository repo;

  MostlyTrendingBloc(this.repo)
      : super(MostlyTrendingInitial()) {

    on<FetchMostlyTrending>(_onFetchMostlyTrending);
  }

  Future<void> _onFetchMostlyTrending(
      FetchMostlyTrending event,
      Emitter<MostlyTrendingState> emit,
      ) async {

    emit(MostlyTrendingLoading());

    try {
      final services = await repo.fetchMostlyTrending();
      emit(MostlyTrendingLoaded(services));
    } catch (e) {
      emit(MostlyTrendingError(e.toString()));
    }
  }
}
