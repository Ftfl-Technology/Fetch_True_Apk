import 'package:equatable/equatable.dart';
import '../../model/on_demand_popular_provider_model.dart';

abstract class OnDemandPopularProviderState extends Equatable {
  const OnDemandPopularProviderState();

  @override
  List<Object?> get props => [];
}

class OnDemandPopularProviderInitial extends OnDemandPopularProviderState {}

class OnDemandPopularProviderLoading extends OnDemandPopularProviderState {}

class OnDemandPopularProviderLoaded extends OnDemandPopularProviderState {
  final OnDemandPopularProviderModel data;

  const OnDemandPopularProviderLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class OnDemandPopularProviderError extends OnDemandPopularProviderState {
  final String message;

  const OnDemandPopularProviderError(this.message);

  @override
  List<Object?> get props => [message];
}
