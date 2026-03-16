import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/on_demand_service_details_repository.dart';
import 'on_demand_service_details_event.dart';
import 'on_demand_service_details_state.dart';


class OnDemandServiceDetailsBloc extends Bloc<OnDemandServiceDetailsEvent, OnDemandServiceDetailsState> {
  final OnDemandServiceDetailsRepository repository;

  OnDemandServiceDetailsBloc({required this.repository}) : super(OnDemandServiceDetailsInitial()) {
    on<FetchOnDemandServiceDetails>((event, emit) async {
      emit(OnDemandServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(OnDemandServiceDetailsLoaded(service));
      } catch (e) {
        emit(OnDemandServiceDetailsError(e.toString()));
      }
    });
  }
}
