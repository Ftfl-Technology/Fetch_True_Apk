import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/understanding_fetch_true_repository.dart';
import 'understanding_fetch_true_event.dart';
import 'understanding_fetch_true_state.dart';

class UnderstandingFetchTrueBloc extends Bloc<UnderstandingFetchTrueEvent, UnderstandingFetchTrueState> {
  final UnderstandingFetchTrueRepository repository;

  UnderstandingFetchTrueBloc(this.repository) : super(UnderstandingFetchTrueInitial()) {
    on<LoadUnderstandingFetchTrue>((event, emit) async {
      emit(UnderstandingFetchTrueLoading());
      try {
        final data = await repository.fetchData();
        emit(UnderstandingFetchTrueLoaded(data));
      } catch (e) {
        emit(UnderstandingFetchTrueError(e.toString()));
      }
    });
  }
}
