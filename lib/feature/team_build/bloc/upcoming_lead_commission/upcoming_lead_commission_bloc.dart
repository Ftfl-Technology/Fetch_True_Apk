import 'package:fetchtrue/feature/team_build/bloc/upcoming_lead_commission/upcoming_lead_commission_event.dart';
import 'package:fetchtrue/feature/team_build/bloc/upcoming_lead_commission/upcoming_lead_commission_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/upcoming_lead_commission_repository.dart';

class UpcomingCommissionBloc
    extends Bloc<UpcomingCommissionEvent, UpcomingCommissionState> {
  final UpcomingLeadCommissionRepository repository;

  UpcomingCommissionBloc(this.repository) : super(UpcomingCommissionInitial()) {
    on<FetchUpcomingCommission>((event, emit) async {
      emit(UpcomingCommissionLoading());
      try {
        final commission = await repository.fetchCommission(event.checkoutId);
        emit(UpcomingCommissionLoaded(commission));
      } catch (e) {
        emit(UpcomingCommissionError(e.toString()));
      }
    });
  }
}
