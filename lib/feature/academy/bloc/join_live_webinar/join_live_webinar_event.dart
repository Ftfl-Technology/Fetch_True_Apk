import 'package:equatable/equatable.dart';

abstract class JoinLiveWebinarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class JoinWebinarEvent extends JoinLiveWebinarEvent {
  final String webinarId;
  final List<String> users;
  final bool status;

  JoinWebinarEvent({
    required this.webinarId,
    required this.users,
    required this.status,
  });

  @override
  List<Object?> get props => [webinarId, users, status];
}
