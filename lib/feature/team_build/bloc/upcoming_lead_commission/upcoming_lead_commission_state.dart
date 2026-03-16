import 'package:equatable/equatable.dart';
import '../../model/upcoming_lead_commission_model.dart';

abstract class UpcomingCommissionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpcomingCommissionInitial extends UpcomingCommissionState {}

class UpcomingCommissionLoading extends UpcomingCommissionState {}

class UpcomingCommissionLoaded extends UpcomingCommissionState {
  final UpcomingLeadCommissionModel commission;

  UpcomingCommissionLoaded(this.commission);

  @override
  List<Object?> get props => [commission];
}

class UpcomingCommissionError extends UpcomingCommissionState {
  final String message;

  UpcomingCommissionError(this.message);

  @override
  List<Object?> get props => [message];
}
