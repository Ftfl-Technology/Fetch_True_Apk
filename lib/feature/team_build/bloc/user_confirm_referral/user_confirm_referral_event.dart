// user_confirm_referral_event.dart
import 'package:equatable/equatable.dart';

abstract class UserConfirmReferralEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ConfirmReferralCodeEvent extends UserConfirmReferralEvent {
  final String userId;
  final String referralCode;

  ConfirmReferralCodeEvent({
    required this.userId,
    required this.referralCode,
  });

  @override
  List<Object?> get props => [userId, referralCode];
}
