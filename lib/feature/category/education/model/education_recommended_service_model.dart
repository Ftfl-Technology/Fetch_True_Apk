class EducationRecommendedServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<EducationRecommendedServiceData> data;

  EducationRecommendedServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory EducationRecommendedServiceModel.fromJson(Map<String, dynamic> json) {
    return EducationRecommendedServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => EducationRecommendedServiceData.fromJson(e))
          .toList(),
    );
  }
}

class EducationRecommendedServiceData {
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

  EducationRecommendedServiceData({
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

  factory EducationRecommendedServiceData.fromJson(Map<String, dynamic> json) {
    return EducationRecommendedServiceData(
      id: json['_id']?.toString() ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',
      keyValues: (json['keyValues'] as List? ?? [])
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
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
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
      id: json['_id']?.toString() ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class ServiceDetails {
  final List<ServicePackage> packages;

  ServiceDetails({required this.packages});

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
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: (json['whatYouGet'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}


class FranchiseDetails {
  final String commission;

  FranchiseDetails({required this.commission});

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission']?.toString() ?? '',
    );
  }
}
