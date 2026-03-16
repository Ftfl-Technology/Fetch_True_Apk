import 'package:equatable/equatable.dart';
import '../../model/on_demand_recommended_provider_model.dart';

abstract class OnDemandRecommendedProviderState extends Equatable {
  const OnDemandRecommendedProviderState();

  @override
  List<Object?> get props => [];
}

class OnDemandRecommendedProviderInitial extends OnDemandRecommendedProviderState {}

class OnDemandRecommendedProviderLoading extends OnDemandRecommendedProviderState {}

class OnDemandRecommendedProviderLoaded extends OnDemandRecommendedProviderState {
  final OnDemandRecommendedProviderModel data;

  const OnDemandRecommendedProviderLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class OnDemandRecommendedProviderError extends OnDemandRecommendedProviderState {
  final String message;

  const OnDemandRecommendedProviderError(this.message);

  @override
  List<Object?> get props => [message];
}
