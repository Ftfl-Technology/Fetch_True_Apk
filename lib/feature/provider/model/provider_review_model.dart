class ProviderReviewModel {
  final bool success;
  final int totalReviews;
  final double averageRating;
  final Map<String, int> ratingDistribution;
  final List<Review> reviews;

  ProviderReviewModel({
    required this.success,
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.reviews,
  });

  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    return ProviderReviewModel(
      success: json['success'] ?? false,
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      ratingDistribution: Map<String, int>.from(
        json['ratingDistribution'] ?? {},
      ),
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
    );
  }
}

class Review {
  final String id;
  final User user;
  final String provider;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.user,
    required this.provider,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      provider: json['provider'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class User {
  final String id;
  final String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
