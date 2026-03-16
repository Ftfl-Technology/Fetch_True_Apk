import 'package:equatable/equatable.dart';

import '../../model/why_just_our_service_model.dart';

abstract class WhyJustOurServiceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WhyJustOurServiceInitial extends WhyJustOurServiceState {}

class WhyJustOurServiceLoading extends WhyJustOurServiceState {}

class WhyJustOurServiceLoaded extends WhyJustOurServiceState {
  final WhyJustOurServiceModel model;

  WhyJustOurServiceLoaded(this.model);

  @override
  List<Object?> get props => [model];
}

class WhyJustOurServiceError extends WhyJustOurServiceState {
  final String message;

  WhyJustOurServiceError(this.message);

  @override
  List<Object?> get props => [message];
}
