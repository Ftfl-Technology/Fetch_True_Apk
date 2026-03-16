import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/my_team_repository.dart';
import 'my_team_event.dart';
import 'my_team_state.dart';

class MyTeamBloc extends Bloc<MyTeamEvent, MyTeamState> {
  final MyTeamRepository repository;

  MyTeamBloc(this.repository) : super(MyTeamInitial()) {
    on<FetchMyTeam>((event, emit) async {
      emit(MyTeamLoading());
      try {
        final response = await repository.getMyTeam(event.userId);
        emit(MyTeamLoaded(response));
      } catch (e) {
        emit(MyTeamError(e.toString()));
      }
    });
  }
}
