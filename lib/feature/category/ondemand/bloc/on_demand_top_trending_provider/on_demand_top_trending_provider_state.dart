import 'package:equatable/equatable.dart';
import '../../model/on_demand_recommended_provider_model.dart';
import '../../model/on_demand_top_trending_provider_model.dart';

abstract class OnDemandTopTrendingProviderState extends Equatable {
  const OnDemandTopTrendingProviderState();

  @override
  List<Object?> get props => [];
}

class OnDemandTopTrendingProviderInitial extends OnDemandTopTrendingProviderState {}

class OnDemandTopTrendingProviderLoading extends OnDemandTopTrendingProviderState {}

class OnDemandTopTrendingProviderLoaded extends OnDemandTopTrendingProviderState {
  final OnDemandTopTrendingProviderModel data;

  const OnDemandTopTrendingProviderLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class OnDemandTopTrendingProviderError extends OnDemandTopTrendingProviderState {
  final String message;

  const OnDemandTopTrendingProviderError(this.message);

  @override
  List<Object?> get props => [message];
}
