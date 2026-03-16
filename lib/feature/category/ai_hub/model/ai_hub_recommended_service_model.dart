class AiHubRecommendedServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<AiHubRecommendedServiceData> data;

  AiHubRecommendedServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory AiHubRecommendedServiceModel.fromJson(Map<String, dynamic> json) {
    return AiHubRecommendedServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AiHubRecommendedServiceData.fromJson(e))
          .toList(),
    );
  }
}

class AiHubRecommendedServiceData {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final String thumbnailImage;
  final List<ServiceKeyValue> keyValues;
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;

  AiHubRecommendedServiceData({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.thumbnailImage,
    required this.keyValues,
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
  });

  factory AiHubRecommendedServiceData.fromJson(Map<String, dynamic> json) {
    return AiHubRecommendedServiceData(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',
      keyValues: (json['keyValues'] as List<dynamic>? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),
      serviceDetails:
      ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
    );
  }
}

class ServiceDetails {
  final List<ServicePackage> packages;

  ServiceDetails({required this.packages});

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      packages: (json['packages'] as List<dynamic>? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),
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
      whatYouGet:
      (json['whatYouGet'] as List<dynamic>? ?? []).cast<String>(),
    );
  }
}


class ServiceCategory {
  final String id;
  final String name;
  final String image;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class ServiceKeyValue {
  final String id;
  final String? key;
  final String value;
  final String? icon;

  ServiceKeyValue({
    required this.id,
    this.key,
    required this.value,
    this.icon,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      id: json['_id'] ?? '',
      key: json['key'], // may be null
      value: json['value'] ?? '',
      icon: json['icon'], // may be null
    );
  }
}

class FranchiseDetails {
  final String commission;

  FranchiseDetails({required this.commission});

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
    );
  }
}
