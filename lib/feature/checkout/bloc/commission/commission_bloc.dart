// commission_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/commission_repository.dart';
import 'commission_event.dart';
import 'commission_state.dart';

class CommissionBloc extends Bloc<CommissionEvent, CommissionState> {
  CommissionBloc() : super(CommissionInitial()) {
    on<GetCommission>((event, emit) async {
      emit(CommissionLoading());
      try {
        final commission = await CommissionRepository.fetchCommission();
        if (commission != null) {
          emit(CommissionLoaded(commission));
        } else {
          emit(CommissionError("No data found"));
        }
      } catch (e) {
        emit(CommissionError(e.toString()));
      }
    });
  }
}
