import 'package:equatable/equatable.dart';

import '../../model/gallery_model.dart';

abstract class GalleryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final GalleryModel gallery;

  GalleryLoaded(this.gallery);

  @override
  List<Object?> get props => [gallery];
}

class GalleryError extends GalleryState {
  final String message;

  GalleryError(this.message);

  @override
  List<Object?> get props => [message];
}
