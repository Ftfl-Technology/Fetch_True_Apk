import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/franchise_repository.dart';
import 'franchise_model_event.dart';
import 'franchise_model_state.dart';

class FranchiseModelBloc
    extends Bloc<FranchiseModelEvent, FranchiseModelState> {
  final FranchiseRepository repository;

  FranchiseModelBloc(this.repository)
      : super(FranchiseModelInitial()) {
    on<FetchFranchiseModel>(_onFetchModel);
  }

  Future<void> _onFetchModel(
      FetchFranchiseModel event,
      Emitter<FranchiseModelState> emit) async {
    emit(FranchiseModelLoading());
    try {
      final result =
      await repository.fetchFranchiseModel(event.serviceId);
      emit(FranchiseModelLoaded(result));
    } catch (e) {
      emit(FranchiseModelError(e.toString()));
    }
  }
}
