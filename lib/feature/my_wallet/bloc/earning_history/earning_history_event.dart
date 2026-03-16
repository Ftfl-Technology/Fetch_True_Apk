import 'package:equatable/equatable.dart';

abstract class EarningHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchEarningHistoryEvent extends EarningHistoryEvent {
  final String userId;
  final int page;
  final int limit;

  FetchEarningHistoryEvent({required this.userId, this.page = 1, this.limit = 20});
}
