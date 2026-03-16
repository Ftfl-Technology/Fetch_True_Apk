class UsedByUserCoupon {
  final String couponId;
  final String couponCode;
  final String couponTitle;
  final String discountType;
  final int amount;
  final int usedCount;
  final int limitPerUser;
  final DateTime startDate;
  final DateTime endDate;

  UsedByUserCoupon({
    required this.couponId,
    required this.couponCode,
    required this.couponTitle,
    required this.discountType,
    required this.amount,
    required this.usedCount,
    required this.limitPerUser,
    required this.startDate,
    required this.endDate,
  });

  factory UsedByUserCoupon.fromJson(Map<String, dynamic> json) {
    return UsedByUserCoupon(
      couponId: json['couponId'],
      couponCode: json['couponCode'],
      couponTitle: json['couponTitle'],
      discountType: json['discountType'],
      amount: json['amount'],
      usedCount: json['usedCount'],
      limitPerUser: json['limitPerUser'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
      'couponCode': couponCode,
      'couponTitle': couponTitle,
      'discountType': discountType,
      'amount': amount,
      'usedCount': usedCount,
      'limitPerUser': limitPerUser,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}