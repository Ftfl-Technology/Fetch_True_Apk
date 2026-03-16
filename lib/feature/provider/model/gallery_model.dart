class GalleryModel {
  final List<String> galleryImages;

  GalleryModel({required this.galleryImages});

  factory GalleryModel.fromJson(Map<String, dynamic> json) {
    return GalleryModel(
      galleryImages: List<String>.from(json['galleryImages']),
    );
  }
}
