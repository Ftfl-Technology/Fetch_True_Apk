class ItTopTrendingServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<ItTopTrendingServiceData> data;

  ItTopTrendingServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory ItTopTrendingServiceModel.fromJson(Map<String, dynamic> json) {
    return ItTopTrendingServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ItTopTrendingServiceData.fromJson(e))
          .toList(),
    );
  }
}

class ItTopTrendingServiceData {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final String thumbnailImage;
  final List<ServiceKeyValue> keyValues;
  final ServiceDetails serviceDetails;
  final FranchiseTrendingDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool isTrending;

  ItTopTrendingServiceData({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.thumbnailImage,
    required this.keyValues,
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.isTrending,
  });

  factory ItTopTrendingServiceData.fromJson(Map<String, dynamic> json) {
    return ItTopTrendingServiceData(
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
      FranchiseTrendingDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isTrending: json['isTrending'] ?? false,
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
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}


class FranchiseTrendingDetails {
  final String commission;

  FranchiseTrendingDetails({required this.commission});

  factory FranchiseTrendingDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseTrendingDetails(
      commission: json['commission'] ?? '',
    );
  }
}
