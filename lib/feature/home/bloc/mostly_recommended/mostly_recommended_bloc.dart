import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/mostly_recommended_repository.dart';
import 'mostly_recommended_event.dart';
import 'mostly_recommended_state.dart';

class MostlyRecommendedBloc
    extends Bloc<MostlyRecommendedEvent, MostlyRecommendedState> {

  final MostlyRecommendedRepository repo;

  MostlyRecommendedBloc(this.repo)
      : super(MostlyRecommendedInitial()) {

    on<FetchMostlyRecommended>(_onFetchMostlyRecommended);
  }

  Future<void> _onFetchMostlyRecommended(
      FetchMostlyRecommended event,
      Emitter<MostlyRecommendedState> emit,
      ) async {

    emit(MostlyRecommendedLoading());

    try {
      final services = await repo.fetchMostlyRecommended();
      emit(MostlyRecommendedLoaded(services));
    } catch (e) {
      emit(MostlyRecommendedError(e.toString()));
    }
  }
}
