import 'package:equatable/equatable.dart';

abstract class FavoriteProviderState extends Equatable {
  const FavoriteProviderState();

  @override
  List<Object?> get props => [];
}

class FavoriteProviderInitial extends FavoriteProviderState {}

class FavoriteProviderLoading extends FavoriteProviderState {
  final String providerId; // 👈 specific index
  const FavoriteProviderLoading(this.providerId);

  @override
  List<Object?> get props => [providerId];
}

class FavoriteProviderSuccess extends FavoriteProviderState {
  final String providerId;
  final String message;

  const FavoriteProviderSuccess(this.providerId, this.message);

  @override
  List<Object?> get props => [providerId, message];
}

class FavoriteProviderFailure extends FavoriteProviderState {
  final String providerId;
  final String error;

  const FavoriteProviderFailure(this.providerId, this.error);

  @override
  List<Object?> get props => [providerId, error];
}
