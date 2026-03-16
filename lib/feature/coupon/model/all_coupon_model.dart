// all_coupon_model.dart

class AllCouponModel {
  bool success;
  List<CouponData> data;

  AllCouponModel({required this.success, required this.data});

  factory AllCouponModel.fromJson(Map<String, dynamic> json) => AllCouponModel(
    success: json["success"],
    data: List<CouponData>.from(json["data"].map((x) => CouponData.fromJson(x))),
  );
}

class CouponData {
  String id;
  String couponType;
  String couponCode;
  String discountType;
  String discountTitle;
  Category? category;
  Service? service;
  Zone zone;
  String discountAmountType;
  double amount;
  double? maxDiscount;
  double? minPurchase;
  String discountCostBearer;
  String couponAppliesTo;
  bool isApprove;
  bool isDeleted;
  bool isActive;
  int? limitPerUser;
  String createdAt;
  String updatedAt;

  // Optional customer field
  String? customer;

  CouponData({
    required this.id,
    required this.couponType,
    required this.couponCode,
    required this.discountType,
    required this.discountTitle,
    this.category,
    this.service,
    required this.zone,
    required this.discountAmountType,
    required this.amount,
    this.maxDiscount,
    this.minPurchase,
    required this.discountCostBearer,
    required this.couponAppliesTo,
    required this.isApprove,
    required this.isDeleted,
    required this.isActive,
    this.limitPerUser,
    required this.createdAt,
    required this.updatedAt,
    this.customer,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
    id: json["_id"],
    couponType: json["couponType"],
    couponCode: json["couponCode"],
    discountType: json["discountType"],
    discountTitle: json["discountTitle"],
    category: json["category"] != null ? Category.fromJson(json["category"]) : null,
    service: json["service"] != null ? Service.fromJson(json["service"]) : null,
    zone: Zone.fromJson(json["zone"]),
    discountAmountType: json["discountAmountType"],
    amount: (json["amount"] as num).toDouble(),
    maxDiscount: json["maxDiscount"] != null ? (json["maxDiscount"] as num).toDouble() : null,
    minPurchase: json["minPurchase"] != null ? (json["minPurchase"] as num).toDouble() : null,
    discountCostBearer: json["discountCostBearer"],
    couponAppliesTo: json["couponAppliesTo"],
    isApprove: json["isApprove"],
    isDeleted: json["isDeleted"],
    isActive: json["isActive"],
    limitPerUser: json["limitPerUser"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    customer: json["customer"],
  );
}

class Category {
  String id;
  String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    name: json["name"],
  );
}

class Service {
  String id;
  String serviceName;

  Service({required this.id, required this.serviceName});

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["_id"],
    serviceName: json["serviceName"],
  );
}

class Zone {
  String id;
  String name;

  Zone({required this.id, required this.name});

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
    id: json["_id"],
    name: json["name"],
  );
}