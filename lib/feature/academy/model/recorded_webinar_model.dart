class RecordedWebinarModel {
  final bool success;
  final List<RecordedWebinar> data;

  RecordedWebinarModel({
    required this.success,
    required this.data,
  });

  factory RecordedWebinarModel.fromJson(Map<String, dynamic> json) {
    return RecordedWebinarModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RecordedWebinar.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class RecordedWebinar {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final List<RecordedVideo> video;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  RecordedWebinar({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.video,
    this.createdAt,
    this.updatedAt,
    required this.version,
  });

  factory RecordedWebinar.fromJson(Map<String, dynamic> json) {
    return RecordedWebinar(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      video: (json['video'] as List<dynamic>?)
          ?.map((e) => RecordedVideo.fromJson(e))
          .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }
}

class RecordedVideo {
  final String id;
  final String videoName;
  final String videoUrl;
  final String videoDescription;
  final String? videoImageUrl; // Optional field for video thumbnail

  RecordedVideo({
    required this.id,
    required this.videoName,
    required this.videoUrl,
    required this.videoDescription,
    this.videoImageUrl,
  });

  factory RecordedVideo.fromJson(Map<String, dynamic> json) {
    return RecordedVideo(
      id: json['_id'] ?? '',
      videoName: json['videoName'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      videoDescription: json['videoDescription'] ?? '',
      videoImageUrl: json['videoImageUrl'],
    );
  }
}
