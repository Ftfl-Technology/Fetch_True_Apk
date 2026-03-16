import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/fivex_repository.dart';
import 'fivex_event.dart';
import 'fivex_state.dart';


class FiveXBloc extends Bloc<FiveXEvent, FiveXState> {
  final FiveXRepository repository;

  FiveXBloc(this.repository) : super(FiveXInitial()) {
    on<FetchFiveX>((event, emit) async {
      emit(FiveXLoading());
      try {
        final data = await repository.fetchFiveXData();
        emit(FiveXLoaded(data));
      } catch (e) {
        emit(FiveXError(e.toString()));
      }
    });
  }
}
