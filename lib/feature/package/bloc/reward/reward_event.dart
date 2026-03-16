import 'package:equatable/equatable.dart';

abstract class RewardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRewardsEvent extends RewardEvent {}
