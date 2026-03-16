import 'package:equatable/equatable.dart';
import '../../model/mostly_popular_model.dart';
import '../../model/mostly_trending_model.dart';

abstract class MostlyTrendingState extends Equatable {
  const MostlyTrendingState();

  @override
  List<Object?> get props => [];
}

class MostlyTrendingInitial extends MostlyTrendingState {}

class MostlyTrendingLoading extends MostlyTrendingState {}

class MostlyTrendingLoaded extends MostlyTrendingState {
  final List<MostlyTrending> services;

  const MostlyTrendingLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class MostlyTrendingError extends MostlyTrendingState {
  final String message;

  const MostlyTrendingError(this.message);

  @override
  List<Object?> get props => [message];
}
