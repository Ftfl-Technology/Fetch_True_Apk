import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/join_live_webinar_repository.dart';
import 'join_live_webinar_event.dart';
import 'join_live_webinar_state.dart';

class JoinLiveWebinarBloc
    extends Bloc<JoinLiveWebinarEvent, JoinLiveWebinarState> {
  final JoinLiveWebinarRepository repository;

  JoinLiveWebinarBloc(this.repository)
      : super(JoinLiveWebinarInitial()) {
    on<JoinWebinarEvent>(_joinWebinar);
  }

  Future<void> _joinWebinar(
      JoinWebinarEvent event,
      Emitter<JoinLiveWebinarState> emit,
      ) async {
    emit(JoinLiveWebinarLoading());

    try {
      final message = await repository.joinWebinar(
        webinarId: event.webinarId,
        users: event.users,
        status: event.status,
      );

      emit(JoinLiveWebinarSuccess(message));
    } catch (e) {
      emit(JoinLiveWebinarFailure(e.toString()));
    }
  }
}
