import 'package:equatable/equatable.dart';
import '../../model/my_team_model.dart';

abstract class MyTeamState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyTeamInitial extends MyTeamState {}

class MyTeamLoading extends MyTeamState {}

class MyTeamLoaded extends MyTeamState {
  final List<MyTeamModel> response;

  MyTeamLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class MyTeamError extends MyTeamState {
  final String message;

  MyTeamError(this.message);

  @override
  List<Object?> get props => [message];
}
