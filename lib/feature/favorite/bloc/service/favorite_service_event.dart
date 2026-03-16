import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends FavoriteEvent {
  final String userId;
  final String serviceId;

  const AddFavoriteEvent(this.userId, this.serviceId);

  @override
  List<Object> get props => [userId, serviceId];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String userId;
  final String serviceId;

  const RemoveFavoriteEvent(this.userId, this.serviceId);

  @override
  List<Object> get props => [userId, serviceId];
}
