import 'package:equatable/equatable.dart';

import '../../model/reward_claim_model.dart';

abstract class ClaimNowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClaimNowDataInitial extends ClaimNowDataState {}

class ClaimNowDataLoading extends ClaimNowDataState {}

class ClaimNowDataLoaded extends ClaimNowDataState {
  final List<ClaimNowDataModel> items;
  ClaimNowDataLoaded(this.items);

  @override
  List<Object?> get props => [items];
}

class ClaimNowDataError extends ClaimNowDataState {
  final String message;
  ClaimNowDataError(this.message);

  @override
  List<Object?> get props => [message];
}
