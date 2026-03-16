import 'package:bloc/bloc.dart';
import '../../repository/business_top_trending_service_repository.dart';
import 'business_top_trending_service_event.dart';
import 'business_top_trending_service_state.dart';


class BusinessTopTrendingServiceBloc extends Bloc<
    BusinessTopTrendingServiceEvent,
    BusinessTopTrendingServiceState> {
  final BusinessTopTrendingServiceRepository repository;

  BusinessTopTrendingServiceBloc(this.repository)
      : super(BusinessTopTrendingServiceInitial()) {
    on<FetchBusinessTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchBusinessTopTrendingServices event,
      Emitter<BusinessTopTrendingServiceState> emit,
      ) async {
    emit(BusinessTopTrendingServiceLoading());
    try {
      final result = await repository.getBusinessTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(BusinessTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(BusinessTopTrendingServiceError(e.toString()));
    }
  }
}
