import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/franchise_service_details_repository.dart';
import 'franchise_service_details_event.dart';
import 'franchise_service_details_state.dart';


class FranchiseServiceDetailsBloc extends Bloc<FranchiseServiceDetailsEvent, FranchiseServiceDetailsState> {
  final FranchiseServiceDetailsRepository repository;

  FranchiseServiceDetailsBloc({required this.repository}) : super(FranchiseServiceDetailsInitial()) {
    on<FetchFranchiseServiceDetails>((event, emit) async {
      emit(FranchiseServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(FranchiseServiceDetailsLoaded(service));
      } catch (e) {
        emit(FranchiseServiceDetailsError(e.toString()));
      }
    });
  }
}
