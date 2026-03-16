import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/reward_repository.dart';
import 'reward_event.dart';
import 'reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final RewardRepository repository;

  RewardBloc(this.repository) : super(RewardInitial()) {
    on<FetchRewardsEvent>((event, emit) async {
      try {
        emit(RewardLoading());
        final rewards = await repository.getRewards();
        emit(RewardLoaded(rewards));
      } catch (e) {
        emit(RewardError(e.toString()));
      }
    });
  }
}
