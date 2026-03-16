// lead_status_state.dart
import 'package:equatable/equatable.dart';

import '../../model/lead_status_model.dart';

abstract class LeadStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LeadStatusInitial extends LeadStatusState {}

class LeadStatusLoading extends LeadStatusState {}

class LeadStatusLoaded extends LeadStatusState {
  final LeadStatusModel leadStatus;

  LeadStatusLoaded(this.leadStatus);

  @override
  List<Object?> get props => [leadStatus];
}

class LeadStatusError extends LeadStatusState {
  final String message;

  LeadStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
