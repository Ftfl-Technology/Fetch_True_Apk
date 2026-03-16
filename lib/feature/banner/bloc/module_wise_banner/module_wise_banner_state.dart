import 'package:equatable/equatable.dart';
import '../../model/module_wise_banner_model.dart';

abstract class ModuleWiseBannerState extends Equatable {
  const ModuleWiseBannerState();

  @override
  List<Object?> get props => [];
}

class ModuleWiseBannerInitial extends ModuleWiseBannerState {}

class ModuleWiseBannerLoading extends ModuleWiseBannerState {}

class ModuleWiseBannerLoaded extends ModuleWiseBannerState {
  final List<ModuleWiseBannerModel> banners;

  const ModuleWiseBannerLoaded(this.banners);

  @override
  List<Object?> get props => [banners];
}

class ModuleWiseBannerError extends ModuleWiseBannerState {
  final String message;

  const ModuleWiseBannerError(this.message);

  @override
  List<Object?> get props => [message];
}
