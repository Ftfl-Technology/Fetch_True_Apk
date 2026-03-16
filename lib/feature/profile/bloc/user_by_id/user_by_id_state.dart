import 'package:equatable/equatable.dart';
import '../../model/user_model.dart';

abstract class UserByIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserByIdInitial extends UserByIdState {}

class UserByIdLoading extends UserByIdState {}

class UserByIdLoaded extends UserByIdState {
  final UserModel user;
  UserByIdLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserByIdError extends UserByIdState {
  final String message;
  UserByIdError(this.message);

  @override
  List<Object?> get props => [message];
}
