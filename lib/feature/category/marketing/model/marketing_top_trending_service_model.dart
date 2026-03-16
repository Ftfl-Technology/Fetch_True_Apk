class MarketingTopTrendingServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<MarketingTopTrendingServiceData> data;

  MarketingTopTrendingServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory MarketingTopTrendingServiceModel.fromJson(Map<String, dynamic> json) {
    return MarketingTopTrendingServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => MarketingTopTrendingServiceData.fromJson(e))
          .toList(),
    );
  }
}

class MarketingTopTrendingServiceData {
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

  MarketingTopTrendingServiceData({
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

  factory MarketingTopTrendingServiceData.fromJson(Map<String, dynamic> json) {
    return MarketingTopTrendingServiceData(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',
      keyValues: (json['keyValues'] as List? ?? [])
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
  final String? icon;
  final String value;

  ServiceKeyValue({
    required this.id,
    this.icon,
    required this.value,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      id: json['_id'] ?? '',
      icon: json['icon'], // optional
      value: json['value'] ?? '',
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
  final String name;
  final double price;
  final double discount;
  final double discountedPrice;

  ServicePackage({
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
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

