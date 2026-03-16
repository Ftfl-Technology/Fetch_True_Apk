import 'package:equatable/equatable.dart';

abstract class ModuleWiseBannerEvent extends Equatable {
  const ModuleWiseBannerEvent();

  @override
  List<Object?> get props => [];
}

class FetchModuleWiseBanner extends ModuleWiseBannerEvent {
  final String moduleId;

  const FetchModuleWiseBanner(this.moduleId);

  @override
  List<Object?> get props => [moduleId];
}
