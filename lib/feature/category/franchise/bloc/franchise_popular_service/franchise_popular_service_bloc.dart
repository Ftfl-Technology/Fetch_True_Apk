import 'package:bloc/bloc.dart';
import '../../repository/franchise_popular_service_repository.dart';
import 'franchise_popular_service_event.dart';
import 'franchise_popular_service_state.dart';


class FranchisePopularServiceBloc extends Bloc<
    FranchisePopularServiceEvent,
    FranchisePopularServiceState> {
  final FranchisePopularServiceRepository repository;

  FranchisePopularServiceBloc(this.repository)
      : super(FranchisePopularServiceInitial()) {
    on<FetchFranchisePopularServices>(_onFetch);
  }

  Future<void> _onFetch(
      FetchFranchisePopularServices event,
      Emitter<FranchisePopularServiceState> emit,
      ) async {
    emit(FranchisePopularServiceLoading());
    try {
      final result = await repository.getFranchisePopularServices(
        moduleId: event.moduleId,
      );
      emit(FranchisePopularServiceLoaded(result));
    } catch (e) {
      emit(FranchisePopularServiceError(e.toString()));
    }
  }
}
