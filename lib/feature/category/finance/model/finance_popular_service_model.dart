class FinancePopularServiceModel {
  final bool success;
  final int count;
  final List<FinancePopularServiceData> data;

  FinancePopularServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory FinancePopularServiceModel.fromJson(Map<String, dynamic> json) {
    return FinancePopularServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => FinancePopularServiceData.fromJson(e))
          .toList(),
    );
  }
}

class FinancePopularServiceData {
  final String serviceId;
  final String serviceName;
  final String thumbnailImage;
  final int price;
  final ServiceCategory category;
  final List<ServiceKeyValue> keyValues;
  final List<ServicePackage> packages;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;

  FinancePopularServiceData({
    required this.serviceId,
    required this.serviceName,
    required this.thumbnailImage,
    required this.price,
    required this.category,
    required this.keyValues,
    required this.packages,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
  });

  factory FinancePopularServiceData.fromJson(Map<String, dynamic> json) {
    return FinancePopularServiceData(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? '',
      price: json['price'] ?? 0,
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      keyValues: (json['keyValues'] as List<dynamic>? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),
      packages: (json['packages'] as List<dynamic>? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }
}

class ServiceCategory {
  final String id;
  final String name;

  ServiceCategory({
    required this.id,
    required this.name,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class ServiceKeyValue {
  final String id;
  final String key;
  final String value;
  final String icon;

  ServiceKeyValue({
    required this.id,
    required this.key,
    required this.value,
    required this.icon,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      id: json['_id'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class ServicePackage {
  final String id;
  final String name;
  final int price;
  final int discount;
  final double discountedPrice;
  final List<String> whatYouGet;

  ServicePackage({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      discountedPrice:
      (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet:
      List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}



class FranchiseDetails {
  final String commission;
  final List<dynamic> investmentRange;
  final List<dynamic> monthlyEarnPotential;

  FranchiseDetails({
    required this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      investmentRange: json['investmentRange'] ?? [],
      monthlyEarnPotential: json['monthlyEarnPotential'] ?? [],
    );
  }
}
