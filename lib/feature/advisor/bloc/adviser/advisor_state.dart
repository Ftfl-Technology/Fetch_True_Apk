import 'package:equatable/equatable.dart';

import '../../model/advisor_model.dart';

abstract class AdvisorState extends Equatable {
  const AdvisorState();

  @override
  List<Object?> get props => [];
}

class AdvisorInitial extends AdvisorState {}

class AdvisorLoading extends AdvisorState {}

class AdvisorLoaded extends AdvisorState {
  final List<AdvisorModel> advisors;

  const AdvisorLoaded(this.advisors);

  @override
  List<Object?> get props => [advisors];
}

class AdvisorEmpty extends AdvisorState {
  const AdvisorEmpty();
}

class AdvisorError extends AdvisorState {
  final String message;

  const AdvisorError(this.message);

  @override
  List<Object?> get props => [message];
}