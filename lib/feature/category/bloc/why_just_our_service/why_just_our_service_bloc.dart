import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/why_just_our_service_repository.dart';
import 'why_just_our_service_event.dart';
import 'why_just_our_service_state.dart';

class WhyJustOurServiceBloc
    extends Bloc<WhyJustOurServiceEvent, WhyJustOurServiceState> {
  final WhyJustOurServiceRepository repository;

  WhyJustOurServiceBloc(this.repository)
      : super(WhyJustOurServiceInitial()) {

    on<GetWhyJustOurServiceEvent>((event, emit) async {
      emit(WhyJustOurServiceLoading());

      try {
        final data = await repository.fetchWhyJustOurService(
          moduleId: event.moduleId,
        );

        emit(WhyJustOurServiceLoaded(data));
      } catch (e) {
        emit(WhyJustOurServiceError(e.toString()));
      }
    });
  }
}
