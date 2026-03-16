import 'package:equatable/equatable.dart';

import '../../model/referral_user_model.dart';

abstract class ReferralState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReferralInitial extends ReferralState {}

class ReferralLoading extends ReferralState {}

class ReferralLoaded extends ReferralState {
  final List<ReferralUser> referrals;

  ReferralLoaded(this.referrals);

  @override
  List<Object> get props => [referrals];
}

class ReferralError extends ReferralState {
  final String message;

  ReferralError(this.message);

  @override
  List<Object> get props => [message];
}
