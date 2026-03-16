class AdvisorResponse {
  final bool success;
  final List<AdvisorModel> data;

  AdvisorResponse({
    required this.success,
    required this.data,
  });

  factory AdvisorResponse.fromJson(Map<String, dynamic> json) {
    return AdvisorResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
          ?.map((e) => AdvisorModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AdvisorModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String phoneNumber;
  final String language;
  final List<String> tags;
  final String chat;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdvisorModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.phoneNumber,
    required this.language,
    required this.tags,
    required this.chat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdvisorModel.fromJson(Map<String, dynamic> json) {
    return AdvisorModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      language: json['language']?.toString() ?? '',
      tags: (json['tags'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      chat: json['chat']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}