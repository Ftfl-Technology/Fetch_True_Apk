import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/module_wise_banner_repository.dart';
import 'module_wise_banner_event.dart';
import 'module_wise_banner_state.dart';

class ModuleWiseBannerBloc
    extends Bloc<ModuleWiseBannerEvent, ModuleWiseBannerState> {
  final ModuleWiseBannerRepository repository;

  ModuleWiseBannerBloc(this.repository)
      : super(ModuleWiseBannerInitial()) {
    on<FetchModuleWiseBanner>(_onFetchBanner);
  }

  Future<void> _onFetchBanner(
      FetchModuleWiseBanner event,
      Emitter<ModuleWiseBannerState> emit,
      ) async {
    emit(ModuleWiseBannerLoading());
    try {
      final banners =
      await repository.getModuleWiseBanners(event.moduleId);
      emit(ModuleWiseBannerLoaded(banners));
    } catch (e) {
      emit(ModuleWiseBannerError(e.toString()));
    }
  }
}
