import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/it_service_details_repository.dart';
import 'it_service_details_event.dart';
import 'it_service_details_state.dart';


class ItServiceDetailsBloc extends Bloc<ItServiceDetailsEvent, ItServiceDetailsState> {
  final ItServiceDetailsRepository repository;

 ItServiceDetailsBloc({required this.repository}) : super(ItServiceDetailsInitial()) {
    on<FetchItServiceDetails>((event, emit) async {
      emit(ItServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(ItServiceDetailsLoaded(service));
      } catch (e) {
        emit(ItServiceDetailsError(e.toString()));
      }
    });
  }
}
