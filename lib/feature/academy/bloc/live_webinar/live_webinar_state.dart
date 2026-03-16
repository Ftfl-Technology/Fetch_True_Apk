part of 'live_webinar_bloc.dart';

abstract class LiveWebinarState extends Equatable {
  const LiveWebinarState();

  @override
  List<Object?> get props => [];
}

class LiveWebinarInitial extends LiveWebinarState {}

class LiveWebinarLoading extends LiveWebinarState {}

class LiveWebinarLoaded extends LiveWebinarState {
  final LiveWebinarModel liveWebinarModel;

  const LiveWebinarLoaded(this.liveWebinarModel);

  @override
  List<Object?> get props => [liveWebinarModel];
}

class LiveWebinarError extends LiveWebinarState {
  final String message;

  const LiveWebinarError(this.message);

  @override
  List<Object?> get props => [message];
}
