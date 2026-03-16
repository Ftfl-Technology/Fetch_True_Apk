import 'package:equatable/equatable.dart';

import '../../model/business_service_details_model.dart';

abstract class BusinessServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BusinessServiceDetailsInitial extends BusinessServiceDetailsState {}

class BusinessServiceDetailsLoading extends BusinessServiceDetailsState {}

class BusinessServiceDetailsLoaded extends BusinessServiceDetailsState {
  final BusinessServiceDetailsModel service;

  BusinessServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class BusinessServiceDetailsError extends BusinessServiceDetailsState {
  final String message;

  BusinessServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
