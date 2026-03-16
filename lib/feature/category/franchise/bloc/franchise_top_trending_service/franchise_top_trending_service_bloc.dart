import 'package:bloc/bloc.dart';

import '../../repository/franchise_top_trending_service_repository.dart';
import 'franchise_top_trending_service_event.dart';
import 'franchise_top_trending_service_state.dart';



class FranchiseTopTrendingServiceBloc extends Bloc<
    FranchiseTopTrendingServiceEvent,
    FranchiseTopTrendingServiceState> {
  final FranchiseTopTrendingServiceRepository repository;

  FranchiseTopTrendingServiceBloc(this.repository)
      : super(FranchiseTopTrendingServiceInitial()) {
    on<FetchFranchiseTopTrendingServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFranchiseTopTrendingServices event,
      Emitter<FranchiseTopTrendingServiceState> emit,
      ) async {
    emit(FranchiseTopTrendingServiceLoading());
    try {
      final result = await repository.getFranchiseTopTrendingServices(
        moduleId: event.moduleId,
      );
      emit(FranchiseTopTrendingServiceLoaded(result));
    } catch (e) {
      emit(FranchiseTopTrendingServiceError(e.toString()));
    }
  }
}
