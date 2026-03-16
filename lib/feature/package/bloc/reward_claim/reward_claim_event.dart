abstract class RewardClaimEvent {}

class SubmitClaimEvent extends RewardClaimEvent {
  final String userId;
  final String rewardId;
  final int selectedIndex;

  SubmitClaimEvent({
    required this.userId,
    required this.rewardId,
    required this.selectedIndex,
  });
}
