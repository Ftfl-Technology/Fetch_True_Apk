import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/legal_service_details_repository.dart';
import 'legal_service_details_event.dart';
import 'legal_service_details_state.dart';


class LegalServiceDetailsBloc extends Bloc<LegalServiceDetailsEvent, LegalServiceDetailsState> {
  final LegalServiceDetailsRepository repository;

  LegalServiceDetailsBloc({required this.repository}) : super(LegalServiceDetailsInitial()) {
    on<FetchLegalServiceDetails>((event, emit) async {
      emit(LegalServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(LegalServiceDetailsLoaded(service));
      } catch (e) {
        emit(LegalServiceDetailsError(e.toString()));
      }
    });
  }
}
