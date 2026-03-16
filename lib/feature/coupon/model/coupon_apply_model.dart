class CouponApplyModel {
  final String couponCode;
  final String userId;
  final String purchaseAmount;
  final String serviceId;
  final String zoneId;

  CouponApplyModel({
    required this.couponCode,
    required this.userId,
    required this.purchaseAmount,
    required this.serviceId,
    required this.zoneId,
  });

  Map<String, dynamic> toJson() {
    return {
      "couponCode": couponCode,
      "userId": userId,
      "purchaseAmount": purchaseAmount,
      "serviceId": serviceId,
      "zoneId": zoneId,
    };
  }
}

class CouponApplyResponse {
  final bool success;
  final CouponData? data;

  CouponApplyResponse({required this.success, this.data});

  factory CouponApplyResponse.fromJson(Map<String, dynamic> json) {
    return CouponApplyResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? CouponData.fromJson(json['data']) : null,
    );
  }
}

class CouponData {
  final String couponId;
  final int discount;

  CouponData({required this.couponId, required this.discount});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      couponId: json['couponId'] ?? '',
      discount: json['discount'] ?? 0,
    );
  }
}
