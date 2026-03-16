// 📦 PartnerReviewModel.dart

class PartnerReviewResponse {
  final bool success;
  final List<PartnerReview> data;

  PartnerReviewResponse({
    required this.success,
    required this.data,
  });

  factory PartnerReviewResponse.fromJson(Map<String, dynamic> json) {
    return PartnerReviewResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PartnerReview.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class PartnerReview {
  final String id;
  final String title;
  final String imageUrl;
  final String videoUrl;

  PartnerReview({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
  });

  factory PartnerReview.fromJson(Map<String, dynamic> json) {
    return PartnerReview(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}
