import 'package:equatable/equatable.dart';

import '../../model/earning_history_model.dart';

abstract class EarningHistoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EarningHistoryInitial extends EarningHistoryState {}

class EarningHistoryLoading extends EarningHistoryState {}

class EarningHistoryLoaded extends EarningHistoryState {
  final List<EarningHistory> earningHistory;

  EarningHistoryLoaded(this.earningHistory);

  @override
  List<Object?> get props => [earningHistory];
}

class EarningHistoryError extends EarningHistoryState {
  final String message;

  EarningHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
