import 'package:equatable/equatable.dart';

import '../../model/legal_service_details_model.dart';


abstract class LegalServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LegalServiceDetailsInitial extends LegalServiceDetailsState {}

class LegalServiceDetailsLoading extends LegalServiceDetailsState {}

class LegalServiceDetailsLoaded extends LegalServiceDetailsState {
  final LegalServiceDetailsModel service;

  LegalServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class LegalServiceDetailsError extends LegalServiceDetailsState {
  final String message;

  LegalServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
