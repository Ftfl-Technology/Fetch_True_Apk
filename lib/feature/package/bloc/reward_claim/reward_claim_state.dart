abstract class RewardClaimState {}

class RewardClaimInitial extends RewardClaimState {}

class RewardClaimLoading extends RewardClaimState {}

class RewardClaimSuccess extends RewardClaimState {
  final String message;
  RewardClaimSuccess(this.message);
}

class RewardClaimError extends RewardClaimState {
  final String error;
  RewardClaimError(this.error);
}
