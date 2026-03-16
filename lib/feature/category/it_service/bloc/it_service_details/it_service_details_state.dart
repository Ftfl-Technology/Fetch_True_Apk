import 'package:equatable/equatable.dart';

import '../../model/it_service_details_model.dart';

abstract class ItServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItServiceDetailsInitial extends ItServiceDetailsState {}

class ItServiceDetailsLoading extends ItServiceDetailsState {}

class ItServiceDetailsLoaded extends ItServiceDetailsState {
  final ItServiceDetailsModel service;

  ItServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class ItServiceDetailsError extends ItServiceDetailsState {
  final String message;

 ItServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
