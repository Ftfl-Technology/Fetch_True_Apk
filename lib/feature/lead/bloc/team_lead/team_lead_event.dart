import 'package:equatable/equatable.dart';

abstract class TeamLeadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTeamLeadsByUser extends TeamLeadEvent {
  final String userId;
  GetTeamLeadsByUser(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ClearLeadData extends TeamLeadEvent {}

