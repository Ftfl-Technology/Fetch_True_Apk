class TrainingTutorialModel {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final List<TutorialVideo> videoList;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TrainingTutorialModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.videoList,
    this.createdAt,
    this.updatedAt,
  });

  factory TrainingTutorialModel.fromJson(Map<String, dynamic> json) {
    return TrainingTutorialModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      videoList: (json['video'] as List? ?? [])
          .map((v) => TutorialVideo.fromJson(v))
          .toList(),
      createdAt:
      json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt:
      json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class TutorialVideo {
  final String id;
  final String videoName;
  final String videoUrl;
  final String videoDescription;
  final String videoImageUrl;

  TutorialVideo({
    required this.id,
    required this.videoName,
    required this.videoUrl,
    required this.videoDescription,
    required this.videoImageUrl,
  });

  factory TutorialVideo.fromJson(Map<String, dynamic> json) {
    return TutorialVideo(
      id: json['_id'] ?? '',
      videoName: json['videoName'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoDescription: json['videoDescription'] ?? '',
      videoImageUrl: json['videoImageUrl'] ?? '',
    );
  }
}
