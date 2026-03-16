import 'package:equatable/equatable.dart';

import '../../model/mostly_recommended_model.dart';

abstract class MostlyRecommendedState extends Equatable {
  const MostlyRecommendedState();

  @override
  List<Object?> get props => [];
}

class MostlyRecommendedInitial extends MostlyRecommendedState {}

class MostlyRecommendedLoading extends MostlyRecommendedState {}

class MostlyRecommendedLoaded extends MostlyRecommendedState {
  final List<MostlyRecommended> services;

  const MostlyRecommendedLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class MostlyRecommendedError extends MostlyRecommendedState {
  final String message;

  const MostlyRecommendedError(this.message);

  @override
  List<Object?> get props => [message];
}
