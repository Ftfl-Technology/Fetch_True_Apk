// lead_status_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/lead_status_repository.dart';
import 'lead_status_event.dart';
import 'lead_status_state.dart';

class LeadStatusBloc extends Bloc<LeadStatusEvent, LeadStatusState> {
  final LeadStatusRepository repository;

  LeadStatusBloc(this.repository) : super(LeadStatusInitial()) {
    on<FetchLeadStatusEvent>(_onFetchLeadStatus);
  }

  Future<void> _onFetchLeadStatus(
      FetchLeadStatusEvent event, Emitter<LeadStatusState> emit) async {
    emit(LeadStatusLoading());
    try {
      final leadStatus = await repository.fetchLeadStatusByCheckout(event.checkoutId);
      if (leadStatus != null) {
        emit(LeadStatusLoaded(leadStatus));
      } else {
        emit(LeadStatusError("No data found"));
      }
    } catch (e) {
      emit(LeadStatusError("Failed to load lead status: $e"));
    }
  }
}
