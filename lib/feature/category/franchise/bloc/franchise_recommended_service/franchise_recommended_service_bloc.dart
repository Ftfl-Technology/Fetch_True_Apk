import 'package:bloc/bloc.dart';
import '../../repository/franchise_recommended_service_repository.dart';
import 'franchise_recommended_service_event.dart';
import 'franchise_recommended_service_state.dart';


class FranchiseRecommendedServiceBloc extends Bloc<
    FranchiseRecommendedServiceEvent,
    FranchiseRecommendedServiceState> {
  final FranchiseRecommendedServiceRepository repository;

  FranchiseRecommendedServiceBloc(this.repository)
      : super(FranchiseRecommendedServiceInitial()) {
    on<FetchFranchiseRecommendedServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFranchiseRecommendedServices event,
      Emitter<FranchiseRecommendedServiceState> emit,
      ) async {
    emit(FranchiseRecommendedServiceLoading());
    try {
      final result = await repository.getFranchiseRecommendedServices(
        moduleId: event.moduleId,
      );
      emit(FranchiseRecommendedServiceLoaded(result));
    } catch (e) {
      emit(FranchiseRecommendedServiceError(e.toString()));
    }
  }
}
