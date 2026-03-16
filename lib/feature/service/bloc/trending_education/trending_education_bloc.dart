import 'package:fetchtrue/feature/service/bloc/trending_education/trending_education_event.dart';
import 'package:fetchtrue/feature/service/bloc/trending_education/trending_education_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/trending_educational_repository.dart';


class TrendingEducationBloc extends Bloc<TrendingEducationEvent, TrendingEducationState> {
  final TrendingEducationalRepository service;

  TrendingEducationBloc(this.service) : super(TrendingEducationInitial()) {
    on<GetEducation>((event, emit) async {
      emit(TrendingEducationLoading());
      try {
        final data = await service.fetchTrendingEducation();
        emit(TrendingEducationLoaded(data));
      } catch (e) {
        emit(TrendingEducationError(e.toString()));
      }
    });
  }
}
