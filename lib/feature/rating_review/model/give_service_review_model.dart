class GiveServiceReviewModel {
  final String userId;
  final String serviceId;
  final String checkoutId;
  final bool isSkip;
  final double rating;
  final String comment;

  GiveServiceReviewModel({
    required this.userId,
    required this.serviceId,
    required this.checkoutId,
    required this.isSkip,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "serviceId": serviceId,
      "checkoutId": checkoutId,
      "isSkip": isSkip,
      "rating": rating,
      "comment": comment,
    };
  }
}

class ServiceReviewResponseModel {
  final bool success;
  final String message;

  ServiceReviewResponseModel({
    required this.success,
    required this.message,
  });

  factory ServiceReviewResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ServiceReviewResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}
