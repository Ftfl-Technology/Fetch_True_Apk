import 'package:equatable/equatable.dart';
import '../../model/lead_model.dart';

abstract class LeadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LeadInitial extends LeadState {}

class LeadLoading extends LeadState {}

// class LeadLoaded extends LeadState {
//   final List<LeadModel> leadModel;
//   LeadLoaded(this.leadModel);
//
//   @override
//   List<Object?> get props => [leadModel];
// }

class LeadLoaded extends LeadState {
  final List<LeadModel> allLeads;
  final List<LeadModel> filteredLeads;
  final String selectedFilter;

  LeadLoaded({
    required this.allLeads,
    required this.filteredLeads,
    required this.selectedFilter,
  });

  @override
  List<Object?> get props => [allLeads, filteredLeads, selectedFilter];

  LeadLoaded copyWith({
    List<LeadModel>? allLeads,
    List<LeadModel>? filteredLeads,
    String? selectedFilter,
  }) {
    return LeadLoaded(
      allLeads: allLeads ?? this.allLeads,
      filteredLeads: filteredLeads ?? this.filteredLeads,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}


class LeadError extends LeadState {
  final String message;
  LeadError(this.message);

  @override
  List<Object?> get props => [message];
}


