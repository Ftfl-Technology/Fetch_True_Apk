import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/mostly_popular_repository.dart';
import 'mostly_popular_event.dart';
import 'mostly_popular_state.dart';

class MostlyPopularBloc
    extends Bloc<MostlyPopularEvent, MostlyPopularState> {

  final MostlyPopularRepository repo;

  MostlyPopularBloc(this.repo)
      : super(MostlyPopularInitial()) {

    on<FetchMostlyPopular>(_onFetchMostlyRecommended);
  }

  Future<void> _onFetchMostlyRecommended(
      FetchMostlyPopular event,
      Emitter<MostlyPopularState> emit,
      ) async {

    emit(MostlyPopularLoading());

    try {
      final services = await repo.fetchMostlyPopular();
      emit(MostlyPopularLoaded(services));
    } catch (e) {
      emit(MostlyPopularError(e.toString()));
    }
  }
}
