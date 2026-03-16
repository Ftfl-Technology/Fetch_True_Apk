class UnderstandingFetchTrueModel {
  final String id;
  final String fullName;
  final String imageUrl;
  final String description;
  final String videoUrl;

  UnderstandingFetchTrueModel({
    required this.id,
    required this.fullName,
    required this.imageUrl,
    required this.description,
    required this.videoUrl,
  });

  factory UnderstandingFetchTrueModel.fromJson(Map<String, dynamic> json) {
    return UnderstandingFetchTrueModel(
      id: json["_id"],
      fullName: json["fullName"],
      imageUrl: json["imageUrl"],
      description: json["description"],
      videoUrl: json["videoUrl"],
    );
  }
}
