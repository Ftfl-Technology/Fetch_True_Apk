import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/lead_model.dart';
import '../../repository/lead_repository.dart';
import 'lead_event.dart';
import 'lead_state.dart';

class LeadBloc extends Bloc<LeadEvent, LeadState> {
  final LeadRepository repository;

  LeadBloc(this.repository) : super(LeadInitial()) {
    on<FetchLeadsByUser>((event, emit) async {
      emit(LeadLoading());
      try {
        final result = await repository.getLead(event.userId);
        if (result != null) {
          final sortedLeads = (result ?? [])
            ..sort((a, b) => (b.createdAt ?? '').compareTo(a.createdAt ?? ''));

          emit(LeadLoaded(
            allLeads: sortedLeads,
            filteredLeads: sortedLeads,
            selectedFilter: 'All',
          ));
        } else {
          emit(LeadError("Failed to fetch leads"));
        }
      } catch (e) {
        emit(LeadError(e.toString()));
      }
    });

    on<ClearLeadData>((event, emit) {
      emit(LeadInitial());
    });

    on<FilterLeads>((event, emit) {
      if (state is LeadLoaded) {
        final loadedState = state as LeadLoaded;
        final allLeads = loadedState.allLeads;

        List<LeadModel> filtered;
        switch (event.filter) {
          case 'Pending':
            filtered = allLeads
                .where((e) =>
            !(e.isAccepted ?? false) &&
                !(e.isCompleted ?? false) &&
                !(e.isCanceled ?? false))
                .toList();
            break;
          case 'Accepted':
            filtered = allLeads
                .where((e) =>
            (e.isAccepted ?? false) &&
                !(e.isCompleted ?? false) &&
                !(e.isCanceled ?? false))
                .toList();
            break;
          case 'Completed':
            filtered =
                allLeads.where((e) => (e.isCompleted ?? false)).toList();
            break;
          case 'Cancel':
            filtered =
                allLeads.where((e) => (e.isCanceled ?? false)).toList();
            break;
          default:
            filtered = allLeads;
        }

        emit(loadedState.copyWith(
          filteredLeads: filtered,
          selectedFilter: event.filter,
        ));
      }
    });

  }
}
