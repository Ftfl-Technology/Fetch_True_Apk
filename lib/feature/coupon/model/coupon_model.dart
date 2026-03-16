class CouponModel {
  final String couponId;
  final String couponCode;
  final String couponType;
  final String discountAmountType;
  final double amount;
  final int minPurchase;
  final int maxDiscount;
  final DateTime endDate;

  CouponModel({
    required this.couponId,
    required this.couponCode,
    required this.couponType,
    required this.discountAmountType,
    required this.amount,
    required this.minPurchase,
    required this.maxDiscount,
    required this.endDate,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: json['couponId'] ?? '',
      couponCode: json['couponCode'] ?? '',
      couponType: json['couponType'] ?? '',
      discountAmountType: json['discountAmountType'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      minPurchase: json['minPurchase'] ?? 0,
      maxDiscount: json['maxDiscount'] ?? 0,
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class CouponResponse {
  final bool success;
  final List<CouponModel> coupons;

  CouponResponse({
    required this.success,
    required this.coupons,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      success: json['success'] ?? false,
      coupons: (json['coupons'] as List)
          .map((e) => CouponModel.fromJson(e))
          .toList(),
    );
  }
}
