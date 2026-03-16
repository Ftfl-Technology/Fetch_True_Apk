import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/earning_history_repository.dart';
import 'earning_history_event.dart';
import 'earning_history_state.dart';

class EarningHistoryBloc extends Bloc<EarningHistoryEvent, EarningHistoryState> {
  final EarningHistoryRepository repository;

  EarningHistoryBloc(this.repository) : super(EarningHistoryInitial()) {
    on<FetchEarningHistoryEvent>((event, emit) async {
      emit(EarningHistoryLoading());
      try {
        final data = await repository.fetchEarningHistory(event.userId, event.page, event.limit);
        emit(EarningHistoryLoaded(data));
      } catch (e) {
        emit(EarningHistoryError(e.toString()));
      }
    });
  }
}
