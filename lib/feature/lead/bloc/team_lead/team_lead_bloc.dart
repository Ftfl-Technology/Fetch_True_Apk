
import 'package:fetchtrue/feature/lead/bloc/team_lead/team_lead_event.dart';
import 'package:fetchtrue/feature/lead/bloc/team_lead/team_lead_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/lead_repository.dart';

class TeamLeadBloc extends Bloc<TeamLeadEvent, TeamLeadState> {
  final LeadRepository repository;

  TeamLeadBloc(this.repository) : super(TeamLeadInitial()) {
    on<GetTeamLeadsByUser>((event, emit) async {
      emit(TeamLeadLoading());
      try {
        final result = await repository.getLead(event.userId);
        if (result != null) {
          emit(TeamLeadLoaded(result));
        } else {
          emit(TeamLeadError("Failed to fetch leads"));
        }
      } catch (e) {
        emit(TeamLeadError(e.toString()));
      }
    });
    on<ClearLeadData>((event, emit) {
      emit(TeamLeadInitial());
    });
  }
}
