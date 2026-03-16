import 'package:equatable/equatable.dart';
import '../../../profile/model/user_model.dart';

abstract class UserReferralState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserReferralInitial extends UserReferralState {}

class UserReferralLoading extends UserReferralState {}

class UserReferralLoaded extends UserReferralState {
  final UserModel user;

  UserReferralLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserReferralError extends UserReferralState {
  final String message;

  UserReferralError(this.message);

  @override
  List<Object?> get props => [message];
}

