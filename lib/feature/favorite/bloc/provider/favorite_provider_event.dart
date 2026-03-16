import 'package:equatable/equatable.dart';

abstract class FavoriteProviderEvent extends Equatable {
  const FavoriteProviderEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteProviderEvent extends FavoriteProviderEvent {
  final String userId;
  final String providerId;

  const AddFavoriteProviderEvent(this.userId, this.providerId);

  @override
  List<Object> get props => [userId, providerId];
}

class RemoveFavoriteProviderEvent extends FavoriteProviderEvent {
  final String userId;
  final String providerId;

  const RemoveFavoriteProviderEvent(this.userId, this.providerId);

  @override
  List<Object> get props => [userId, providerId];
}
