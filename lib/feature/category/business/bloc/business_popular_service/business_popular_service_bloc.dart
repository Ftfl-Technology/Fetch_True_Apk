import 'package:bloc/bloc.dart';
import '../../repository/business_popular_service_repository.dart';
import 'business_popular_service_event.dart';
import 'business_popular_service_state.dart';



class BusinessPopularServiceBloc extends Bloc<
    BusinessPopularServiceEvent,
    BusinessPopularServiceState> {
  final BusinessPopularServiceRepository repository;

  BusinessPopularServiceBloc(this.repository)
      : super(BusinessPopularServiceInitial()) {
    on<FetchBusinessPopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchBusinessPopularServices event,
      Emitter<BusinessPopularServiceState> emit,
      ) async {
    emit(BusinessPopularServiceLoading());
    try {
      final result = await repository.getBusinessPopularServices(
        moduleId: event.moduleId,
      );
      emit(BusinessPopularServiceLoaded(result));
    } catch (e) {
      emit(BusinessPopularServiceError(e.toString()));
    }
  }
}
