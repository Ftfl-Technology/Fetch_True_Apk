import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/banner_repository.dart';
import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository repository;

  BannerBloc(this.repository) : super(BannerInitial()) {
    on<GetBanners>((event, emit) async {
      emit(BannerLoading());
      try {
        final banners = await repository.getBanner();
        emit(BannerLoaded(banners));
      } catch (e) {
        emit(BannerError(e.toString()));
      }
    });
  }
}
