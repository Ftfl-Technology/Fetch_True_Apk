import 'package:equatable/equatable.dart';
import '../../model/marketing_service_details_model.dart';

abstract class MarketingServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketingServiceDetailsInitial extends MarketingServiceDetailsState {}

class MarketingServiceDetailsLoading extends MarketingServiceDetailsState {}

class MarketingServiceDetailsLoaded extends MarketingServiceDetailsState {
  final MarketingServiceDetailsModel service;

  MarketingServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class MarketingServiceDetailsError extends MarketingServiceDetailsState {
  final String message;

  MarketingServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
