import 'package:equatable/equatable.dart';

abstract class JoinLiveWebinarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JoinLiveWebinarInitial extends JoinLiveWebinarState {}

class JoinLiveWebinarLoading extends JoinLiveWebinarState {}

class JoinLiveWebinarSuccess extends JoinLiveWebinarState {
  final String message;

  JoinLiveWebinarSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class JoinLiveWebinarFailure extends JoinLiveWebinarState {
  final String error;

  JoinLiveWebinarFailure(this.error);

  @override
  List<Object?> get props => [error];
}
