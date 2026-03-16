import 'package:fetchtrue/feature/service/bloc/trending_marketing/trending_marketing_event.dart';
import 'package:fetchtrue/feature/service/bloc/trending_marketing/trending_marketing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/trending_marketing_repository.dart';


class TrendingMarketingBloc extends Bloc<TrendingMarketingEvent, TrendingMarketingState> {
  final TrendingMarketingRepository service;

  TrendingMarketingBloc(this.service) : super(TrendingMarketingInitial()) {
    on<GetMarketing>((event, emit) async {
      emit(TrendingMarketingLoading());
      try {
        final data = await service.fetchTrendingMarketing();
        emit(TrendingMarketingLoaded(data));
      } catch (e) {
        emit(TrendingMarketingError(e.toString()));
      }
    });
  }
}
