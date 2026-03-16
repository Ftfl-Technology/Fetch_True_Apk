class Review {
  final String id;
  final String userEmail;
  final double rating; // ⚡ changed from int to double
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userEmail,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      userEmail: json['user']['email'],
      rating: (json['rating'] as num).toDouble(), // ⚡ convert to double
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ServiceReviewResponse {
  final bool success;
  final int totalReviews;
  final double averageRating;
  final Map<int, int> ratingDistribution;
  final List<Review> reviews;

  ServiceReviewResponse({
    required this.success,
    required this.totalReviews,
    required this.averageRating,
    required this.ratingDistribution,
    required this.reviews,
  });

  factory ServiceReviewResponse.fromJson(Map<String, dynamic> json) {
    final reviewsList = (json['reviews'] as List)
        .map((reviewJson) => Review.fromJson(reviewJson))
        .toList();

    // ✅ Convert string keys to int
    final Map<int, int> ratingDist = {};
    (json['ratingDistribution'] as Map<String, dynamic>).forEach((key, value) {
      ratingDist[int.parse(key)] = value;
    });

    return ServiceReviewResponse(
      success: json['success'],
      totalReviews: json['totalReviews'],
      averageRating: (json['averageRating'] as num).toDouble(),
      ratingDistribution: ratingDist,
      reviews: reviewsList,
    );
  }
}
