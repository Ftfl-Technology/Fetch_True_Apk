import 'package:equatable/equatable.dart';

import '../../model/on_demand_service_details_model.dart';

abstract class OnDemandServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnDemandServiceDetailsInitial extends OnDemandServiceDetailsState {}

class OnDemandServiceDetailsLoading extends OnDemandServiceDetailsState {}

class OnDemandServiceDetailsLoaded extends OnDemandServiceDetailsState {
  final OnDemandServiceDetailsModel service;

  OnDemandServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class OnDemandServiceDetailsError extends OnDemandServiceDetailsState {
  final String message;

  OnDemandServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
