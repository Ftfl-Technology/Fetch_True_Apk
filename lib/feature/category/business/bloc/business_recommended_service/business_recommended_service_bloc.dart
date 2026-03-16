import 'package:bloc/bloc.dart';
import '../../repository/business_recommended_service_repository.dart';
import 'business_recommended_service_event.dart';
import 'business_recommended_service_state.dart';


class BusinessRecommendedServiceBloc extends Bloc<
    BusinessRecommendedServiceEvent,
    BusinessRecommendedServiceState> {
  final BusinessRecommendedServiceRepository repository;

  BusinessRecommendedServiceBloc(this.repository)
      : super(BusinessRecommendedServiceInitial()) {
    on<FetchBusinessRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchBusinessRecommendedServices event,
      Emitter<BusinessRecommendedServiceState> emit,
      ) async {
    emit(BusinessRecommendedServiceLoading());
    try {
      final result = await repository.getBusinessRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(BusinessRecommendedServiceLoaded(result));
    } catch (e) {
      emit(BusinessRecommendedServiceError(e.toString()));
    }
  }
}
