import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/ads_repository.dart';
import 'ads_event.dart';
import 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final AdsRepository repository;

  AdsBloc(this.repository) : super(AdsInitial()) {
    on<LoadAdsEvent>((event, emit) async {
      emit(AdsLoading());
      try {
        final ads = await repository.getAds();
        emit(AdsLoaded(ads));
      } catch (e) {
        emit(AdsError(e.toString()));
      }
    });
  }
}
