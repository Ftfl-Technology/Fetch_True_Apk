import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadGallery extends GalleryEvent {
  final String providerId;

  LoadGallery(this.providerId);

  @override
  List<Object?> get props => [providerId];
}
