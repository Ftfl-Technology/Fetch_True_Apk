import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/reward_claim_repository.dart';
import 'reward_claim_event.dart';
import 'reward_claim_state.dart';

class RewardClaimBloc extends Bloc<RewardClaimEvent, RewardClaimState> {
  final RewardClaimRepository repository;

  RewardClaimBloc(this.repository) : super(RewardClaimInitial()) {
    on<SubmitClaimEvent>(_onSubmitClaim);
  }

  Future<void> _onSubmitClaim(
      SubmitClaimEvent event, Emitter<RewardClaimState> emit) async {
    emit(RewardClaimLoading());

    try {
      final result = await repository.submitClaim(
        userId: event.userId,
        rewardId: event.rewardId,
        selectedIndex: event.selectedIndex,
      );

      emit(RewardClaimSuccess(result));
    } catch (e) {
      emit(RewardClaimError(e.toString()));
    }
  }
}
