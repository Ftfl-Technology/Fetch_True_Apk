// user_confirm_referral_state.dart
import 'package:equatable/equatable.dart';

abstract class UserConfirmReferralState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserConfirmReferralInitial extends UserConfirmReferralState {}

class UserConfirmReferralLoading extends UserConfirmReferralState {}

class UserConfirmReferralLoaded extends UserConfirmReferralState {}

class UserConfirmReferralError extends UserConfirmReferralState {
  final String message;
  UserConfirmReferralError(this.message);

  @override
  List<Object?> get props => [message];
}
