import 'package:fetchtrue/feature/service/bloc/trending_franchise/trending_franchise_event.dart';
import 'package:fetchtrue/feature/service/bloc/trending_franchise/trending_franchise_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/trending_franchise_repository.dart';


class FranchiseBloc extends Bloc<FranchiseEvent, FranchiseState> {
  final TrendingFranchiseRepository service;

  FranchiseBloc(this.service) : super(FranchiseInitial()) {
    on<FetchFranchises>((event, emit) async {
      emit(FranchiseLoading());
      try {
        final data = await service.fetchTrendingFranchises();
        emit(FranchiseLoaded(data));
      } catch (e) {
        emit(FranchiseError(e.toString()));
      }
    });
  }
}
