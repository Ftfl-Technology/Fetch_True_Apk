class ItPopularServiceModel {
  final bool success;
  final int count;
  final List<ItRecommendedServiceData> data;

  ItPopularServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ItPopularServiceModel.fromJson(Map<String, dynamic> json) {
    return ItPopularServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ItRecommendedServiceData.fromJson(e))
          .toList(),
    );
  }
}

class ItRecommendedServiceData {
  final String serviceId;
  final String serviceName;
  final String thumbnailImage;
  final double price;
  final ServiceCategory category;
  final List<ServiceKeyValue> keyValues;
  final int totalReviews;
  final double averageRating;

  /// FIXED → nested inside serviceDetails
  final List<ServicePackage> packages;

  final FranchiseDetails franchiseDetails;

  ItRecommendedServiceData({
    required this.serviceId,
    required this.serviceName,
    required this.thumbnailImage,
    required this.price,
    required this.category,
    required this.keyValues,
    required this.totalReviews,
    required this.averageRating,
    required this.packages,
    required this.franchiseDetails,
  });

  factory ItRecommendedServiceData.fromJson(Map<String, dynamic> json) {
    final serviceDetails = json['serviceDetails'] ?? {};

    return ItRecommendedServiceData(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? '',
      price: (json['price'] ?? 0).toDouble(),

      category: ServiceCategory.fromJson(json['category'] ?? {}),

      keyValues: (json['keyValues'] as List<dynamic>? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),

      totalReviews: json['totalReviews'] ?? 0,

      averageRating: (json['averageRating'] ?? 0).toDouble(),

      /// ✅ CORRECT PATH
      packages: (serviceDetails['packages'] as List<dynamic>? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),

      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
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

class FranchiseDetails {
  final String commission;
  final String areaRequired;
  final List<dynamic> investmentRange;
  final List<dynamic> monthlyEarnPotential;
  final List<dynamic> franchiseModel;

  FranchiseDetails({
    required this.commission,
    required this.areaRequired,
    required this.investmentRange,
    required this.monthlyEarnPotential,
    required this.franchiseModel,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      areaRequired: json['areaRequired'] ?? '',
      investmentRange: json['investmentRange'] ?? [],
      monthlyEarnPotential: json['monthlyEarnPotential'] ?? [],
      franchiseModel: json['franchiseModel'] ?? [],
    );
  }
}

class ServicePackage {
  final String id;
  final String name;
  final double price;
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
      price: (json['price'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}
