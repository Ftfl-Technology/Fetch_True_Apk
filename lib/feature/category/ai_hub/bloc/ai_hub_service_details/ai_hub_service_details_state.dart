import 'package:equatable/equatable.dart';
import '../../model/ai_hub_service_details_model.dart';

abstract class AiHubServiceDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AiHubServiceDetailsInitial extends AiHubServiceDetailsState {}

class AiHubServiceDetailsLoading extends AiHubServiceDetailsState {}

class AiHubServiceDetailsLoaded extends AiHubServiceDetailsState {
  final AiHubServiceDetailsModel service;

  AiHubServiceDetailsLoaded(this.service);

  @override
  List<Object?> get props => [service];
}

class AiHubServiceDetailsError extends AiHubServiceDetailsState {
  final String message;

  AiHubServiceDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
