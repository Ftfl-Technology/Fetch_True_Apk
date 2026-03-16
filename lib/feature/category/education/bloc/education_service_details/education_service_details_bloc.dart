import 'package:fetchtrue/feature/category/education/repository/education_service_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'education_service_details_event.dart';
import 'education_service_details_state.dart';


class EducationServiceDetailsBloc extends Bloc<EducationServiceDetailsEvent, EducationServiceDetailsState> {
  final EducationServiceDetailsRepository repository;

  EducationServiceDetailsBloc({required this.repository}) : super(EducationServiceDetailsInitial()) {
    on<FetchEducationServiceDetails>((event, emit) async {
      emit(EducationServiceDetailsLoading());
      try {
        final service = await repository.getServiceById(event.serviceId);
        emit(EducationServiceDetailsLoaded(service));
      } catch (e) {
        emit(EducationServiceDetailsError(e.toString()));
      }
    });
  }
}
