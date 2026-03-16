import 'package:equatable/equatable.dart';

abstract class UserByIdEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserById extends UserByIdEvent {
  final String userId;
  FetchUserById(this.userId);

  @override
  List<Object?> get props => [userId];
}
