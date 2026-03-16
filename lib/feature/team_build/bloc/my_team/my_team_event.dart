import 'package:equatable/equatable.dart';

abstract class MyTeamEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMyTeam extends MyTeamEvent {
  final String userId;

  FetchMyTeam(this.userId);

  @override
  List<Object?> get props => [userId];
}
