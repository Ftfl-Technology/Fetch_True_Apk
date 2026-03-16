import 'package:equatable/equatable.dart';
import '../../model/mostly_popular_model.dart';

abstract class MostlyPopularState extends Equatable {
  const MostlyPopularState();

  @override
  List<Object?> get props => [];
}

class MostlyPopularInitial extends MostlyPopularState {}

class MostlyPopularLoading extends MostlyPopularState {}

class MostlyPopularLoaded extends MostlyPopularState {
  final List<MostlyPopular> services;

  const MostlyPopularLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class MostlyPopularError extends MostlyPopularState {
  final String message;

  const MostlyPopularError(this.message);

  @override
  List<Object?> get props => [message];
}
