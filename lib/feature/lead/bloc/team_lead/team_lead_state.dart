import 'package:equatable/equatable.dart';
import '../../model/lead_model.dart';

abstract class TeamLeadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TeamLeadInitial extends TeamLeadState {}

class TeamLeadLoading extends TeamLeadState {}

class TeamLeadLoaded extends TeamLeadState {
  final List<LeadModel> leadModel;
  TeamLeadLoaded(this.leadModel);

  @override
  List<Object?> get props => [leadModel];
}

class TeamLeadError extends TeamLeadState {
  final String message;
  TeamLeadError(this.message);

  @override
  List<Object?> get props => [message];
}
