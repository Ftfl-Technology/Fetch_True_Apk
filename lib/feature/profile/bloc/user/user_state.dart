import 'package:equatable/equatable.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserState {
  final UserModel user;
  UserUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfilePhotoUpdated extends UserState {
  final UserModel user;
  ProfilePhotoUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String massage;
  UserError(this.massage);

  @override
  List<Object?> get props => [massage];
}


class UserDeleted extends UserState {}
