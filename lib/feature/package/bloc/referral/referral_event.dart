import 'package:equatable/equatable.dart';

abstract class ReferralEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadReferrals extends ReferralEvent {
  final String userId;
  LoadReferrals(this.userId);

  @override
  List<Object> get props => [userId];
}
