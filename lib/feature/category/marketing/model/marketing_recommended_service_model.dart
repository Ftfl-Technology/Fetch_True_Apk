class MarketingRecommendedServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<FranchiseRecommendedServiceData> data;

  MarketingRecommendedServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory MarketingRecommendedServiceModel.fromJson(Map<String, dynamic> json) {
    return MarketingRecommendedServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => FranchiseRecommendedServiceData.fromJson(e))
          .toList(),
    );
  }
}

class FranchiseRecommendedServiceData {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final String thumbnailImage;
  final List<ServiceKeyValue> keyValues;
  final List<ServicePackage> packages; // directly flattened
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;

  FranchiseRecommendedServiceData({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.thumbnailImage,
    required this.keyValues,
    required this.packages,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
  });

  factory FranchiseRecommendedServiceData.fromJson(Map<String, dynamic> json) {
    return FranchiseRecommendedServiceData(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',

      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),

      // 👉 handle missing serviceDetails safely
      packages: (json['serviceDetails']?['packages'] as List? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),

      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),

      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
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
  final String icon;
  final String value;

  ServiceKeyValue({
    required this.id,
    required this.icon,
    required this.value,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      id: json['_id'] ?? '',
      icon: json['icon'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class FranchiseDetails {
  final String commission;

  FranchiseDetails({
    required this.commission,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
    );
  }
}
