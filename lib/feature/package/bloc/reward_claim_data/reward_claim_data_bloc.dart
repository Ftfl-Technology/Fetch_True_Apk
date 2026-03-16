import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetchtrue/feature/package/bloc/reward_claim_data/reward_claim_data_event.dart';
import 'package:fetchtrue/feature/package/bloc/reward_claim_data/reward_claim_data_state.dart';

import '../../repository/RewardClaimDataRepo.dart';


class ClaimNowDataBloc extends Bloc<ClaimNowDataEvent, ClaimNowDataState> {
  final ClaimNowDataRepository repository;

  ClaimNowDataBloc(this.repository) : super(ClaimNowDataInitial()) {
    on<FetchClaimNowDataEvent>((event, emit) async {
      emit(ClaimNowDataLoading());

      try {
        final list = await repository.fetchClaimNowData();
        emit(ClaimNowDataLoaded(list));
      } catch (e) {
        emit(ClaimNowDataError(e.toString()));
      }
    });
  }
}
