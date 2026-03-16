class GiveProviderReviewModel {
  final String userId;
  final String providerId;
  final String checkoutId;
  final bool isSkip;
  final double rating;
  final String comment;

  GiveProviderReviewModel({
    required this.userId,
    required this.providerId,
    required this.checkoutId,
    required this.isSkip,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "providerId": providerId,
      "checkoutId": checkoutId,
      "isSkip": isSkip,
      "rating": rating,
      "comment": comment,
    };
  }
}

class ProviderReviewResponseModel {
  final bool success;
  final String message;

  ProviderReviewResponseModel({
    required this.success,
    required this.message,
  });

  factory ProviderReviewResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ProviderReviewResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
