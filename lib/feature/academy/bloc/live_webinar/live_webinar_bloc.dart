import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/live_webinar_model.dart';
import '../../repository/live_webinar_repository.dart';

part 'live_webinar_event.dart';
part 'live_webinar_state.dart';

class LiveWebinarBloc extends Bloc<LiveWebinarEvent, LiveWebinarState> {
  final LiveWebinarRepository repository;

  LiveWebinarBloc(this.repository) : super(LiveWebinarInitial()) {
    on<FetchLiveWebinarsEvent>(_onFetchLiveWebinars);
    on<RefreshLiveWebinarsEvent>(_onRefreshLiveWebinars);
  }

  /// 🔹 Handle initial fetch
  Future<void> _onFetchLiveWebinars(
      FetchLiveWebinarsEvent event, Emitter<LiveWebinarState> emit) async {
    emit(LiveWebinarLoading());
    try {
      final data = await repository.fetchLiveWebinars();
      emit(LiveWebinarLoaded(data));
    } catch (e) {
      emit(LiveWebinarError('Failed to load webinars: ${e.toString()}'));
    }
  }

  /// 🔹 Handle refresh without showing loading spinner
  Future<void> _onRefreshLiveWebinars(
      RefreshLiveWebinarsEvent event, Emitter<LiveWebinarState> emit) async {
    try {
      final data = await repository.fetchLiveWebinars();
      emit(LiveWebinarLoaded(data));
    } catch (e) {
      emit(LiveWebinarError('Failed to refresh webinars: ${e.toString()}'));
    }
  }
}
