class AiHubPopularServiceModel {
  final bool success;
  final int count;
  final List<AiHubPopularServiceData> data;

  AiHubPopularServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory AiHubPopularServiceModel.fromJson(Map<String, dynamic> json) {
    return AiHubPopularServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => AiHubPopularServiceData.fromJson(e))
          .toList(),
    );
  }
}

class AiHubPopularServiceData {
  final String serviceId;
  final String serviceName;
  final String thumbnailImage;
  final num price;
  final ServiceCategory category;
  final List<ServiceKeyValue> keyValues;
  final int totalReviews;
  final double averageRating;

  /// NEW
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;

  AiHubPopularServiceData({
    required this.serviceId,
    required this.serviceName,
    required this.thumbnailImage,
    required this.price,
    required this.category,
    required this.keyValues,
    required this.totalReviews,
    required this.averageRating,
    required this.serviceDetails,
    required this.franchiseDetails,
  });

  factory AiHubPopularServiceData.fromJson(Map<String, dynamic> json) {
    return AiHubPopularServiceData(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? '',
      price: json['price'] ?? 0,
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),

      serviceDetails:
      ServiceDetails.fromJson(json['serviceDetails'] ?? {}),

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

class ServiceDetails {
  final List<ServicePackage> packages;

  ServiceDetails({
    required this.packages,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      packages: (json['packages'] as List? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),
    );
  }
}


class ServicePackage {
  final String id;
  final String name;
  final num price;
  final num discount;
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
      investmentRange:
      json['investmentRange'] as List? ?? [],
      monthlyEarnPotential:
      json['monthlyEarnPotential'] as List? ?? [],
      franchiseModel:
      json['franchiseModel'] as List? ?? [],
    );
  }
}
