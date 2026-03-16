import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUserById extends UserEvent {
  final String userId;
  GetUserById(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateUser extends UserEvent {
  final String userId;
  final Map<String, dynamic> updatedData;

  UpdateUser(this.userId, this.updatedData);

  @override
  List<Object?> get props => [userId, updatedData];
}

class UpdateProfilePhoto extends UserEvent {
  final String userId;
  final String filePath;

  UpdateProfilePhoto(this.userId, this.filePath);

  @override
  List<Object?> get props => [userId, filePath];
}

class ResetUser extends UserEvent {}

class DeleteUser extends UserEvent {
  final String userId;
  DeleteUser(this.userId);

  @override
  List<Object?> get props => [userId];
}


