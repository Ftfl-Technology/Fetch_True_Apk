part of 'live_webinar_bloc.dart';

abstract class LiveWebinarEvent extends Equatable {
  const LiveWebinarEvent();

  @override
  List<Object?> get props => [];
}

/// 🔹 Fetch event
class FetchLiveWebinarsEvent extends LiveWebinarEvent {}

/// 🔹 Refresh event
class RefreshLiveWebinarsEvent extends LiveWebinarEvent {}
