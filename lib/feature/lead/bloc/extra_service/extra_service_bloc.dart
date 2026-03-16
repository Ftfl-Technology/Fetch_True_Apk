import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/extra_service_repository.dart';
import 'extra_service_event.dart';
import 'extra_service_state.dart';

class ExtraServiceBloc extends Bloc<ExtraServiceEvent, ExtraServiceState> {
  final ExtraServiceRepository repository;

  ExtraServiceBloc(this.repository) : super(ExtraServiceInitial()) {
    on<FetchExtraServiceEvent>((event, emit) async {
      emit(ExtraServiceLoading());
      try {
        final response = await repository.fetchExtraServices(event.checkoutId);

        emit(ExtraServiceLoaded(
          services: response.services,
          isAdminApproved: response.isAdminApproved,
        ));
      } catch (e) {
        emit(ExtraServiceError(e.toString()));
      }
    });
  }
}
