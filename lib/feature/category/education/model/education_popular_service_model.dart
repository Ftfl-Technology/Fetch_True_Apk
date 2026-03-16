class EducationPopularServiceModel {
  final bool success;
  final int count;
  final List<EducationPopularServiceData> data;

  EducationPopularServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory EducationPopularServiceModel.fromJson(Map<String, dynamic> json) {
    return EducationPopularServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EducationPopularServiceData.fromJson(e))
          .toList(),
    );
  }
}

class EducationPopularServiceData {
  final String serviceId;
  final String serviceName;
  final String thumbnailImage;
  final int price;
  final ServiceCategory category;
  final List<ServiceKeyValue> keyValues;
  final List<ServicePackage> packages;
  final FranchisePopularDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;

  EducationPopularServiceData({
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

  factory EducationPopularServiceData.fromJson(Map<String, dynamic> json) {
    return EducationPopularServiceData(
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
      FranchisePopularDetails.fromJson(json['franchiseDetails'] ?? {}),
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
      (json['whatYouGet'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class FranchisePopularDetails {
  final String commission;
  final List<dynamic> investmentRange;
  final List<dynamic> monthlyEarnPotential;

  FranchisePopularDetails({
    required this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
  });

  factory FranchisePopularDetails.fromJson(Map<String, dynamic> json) {
    return FranchisePopularDetails(
      commission: json['commission'] ?? '',
      investmentRange:
      json['investmentRange'] as List<dynamic>? ?? [],
      monthlyEarnPotential:
      json['monthlyEarnPotential'] as List<dynamic>? ?? [],
    );
  }
}
