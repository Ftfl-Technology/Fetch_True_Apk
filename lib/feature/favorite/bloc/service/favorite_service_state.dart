import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {
  final String serviceId; // 👈 specific index
  const FavoriteLoading(this.serviceId);

  @override
  List<Object?> get props => [serviceId];
}

class FavoriteSuccess extends FavoriteState {
  final String serviceId;
  final String message;

  const FavoriteSuccess(this.serviceId, this.message);

  @override
  List<Object?> get props => [serviceId, message];
}

class FavoriteFailure extends FavoriteState {
  final String serviceId;
  final String error;

  const FavoriteFailure(this.serviceId, this.error);

  @override
  List<Object?> get props => [serviceId, error];
}
