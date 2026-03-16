import 'package:fetchtrue/feature/category/education/repository/education_service_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/business_service_details_repository.dart';
import 'business_service_details_event.dart';
import 'business_service_details_state.dart';


class BusinessServiceDetailsBloc extends Bloc<BusinessServiceDetailsEvent, BusinessServiceDetailsState> {
  final BusinessServiceDetailsRepository repository;

  BusinessServiceDetailsBloc({required this.repository}) : super(BusinessServiceDetailsInitial()) {
    on<FetchBusinessServiceDetails>((event, emit) async {
      emit(BusinessServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(BusinessServiceDetailsLoaded(service));
      } catch (e) {
        emit(BusinessServiceDetailsError(e.toString()));
      }
    });
  }
}
