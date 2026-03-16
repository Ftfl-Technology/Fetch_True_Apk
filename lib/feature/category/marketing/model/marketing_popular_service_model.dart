class MarketingPopularServiceModel {
  final bool success;
  final int count;
  final List<MarketingPopularServiceData> data;

  MarketingPopularServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory MarketingPopularServiceModel.fromJson(Map<String, dynamic> json) {
    return MarketingPopularServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => MarketingPopularServiceData.fromJson(e))
          .toList(),
    );
  }
}

class MarketingPopularServiceData {
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

  MarketingPopularServiceData({
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

  factory MarketingPopularServiceData.fromJson(Map<String, dynamic> json) {
    return MarketingPopularServiceData(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? '',
      price: json['price'] ?? 0,
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),

      // 👉 packages inside serviceDetails
      packages: (json['serviceDetails']?['packages'] as List? ?? [])
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
  final String value;
  final String icon;

  ServiceKeyValue({
    required this.id,
    required this.value,
    required this.icon,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      id: json['_id'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class ServicePackage {
  final String id;
  final String name;
  final double price;
  final double discount;
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
      discount: (json['discount'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}

class FranchiseDetails {
  final String commission;
  final List<dynamic> investmentRange;
  final List<dynamic> monthlyEarnPotential;
  final String areaRequired;
  final List<dynamic> franchiseModel;

  FranchiseDetails({
    required this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
    required this.areaRequired,
    required this.franchiseModel,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      investmentRange: json['investmentRange'] ?? [],
      monthlyEarnPotential: json['monthlyEarnPotential'] ?? [],
      areaRequired: json['areaRequired'] ?? '',
      franchiseModel: json['franchiseModel'] ?? [],
    );
  }
}
