import 'package:equatable/equatable.dart';

abstract class LeadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchLeadsByUser extends LeadEvent {
  final String userId;
  FetchLeadsByUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClearLeadData extends LeadEvent {}

class FilterLeads extends LeadEvent {
  final String filter;
  FilterLeads(this.filter);

  @override
  List<Object?> get props => [filter];
}


