class ModuleWiseRecommendedServiceResponse {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<RecommendedService> data;

  ModuleWiseRecommendedServiceResponse({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory ModuleWiseRecommendedServiceResponse.fromJson(Map<String, dynamic> json) {
    return ModuleWiseRecommendedServiceResponse(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => RecommendedService.fromJson(e))
          .toList(),
    );
  }
}

class RecommendedService {
  final String id;
  final String serviceName;
  final Category category;
  final String? thumbnailImage;
  final List<KeyValueModel> keyValues;
  final ServiceDetails? serviceDetails;
  final FranchiseDetails? franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;

  RecommendedService({
    required this.id,
    required this.serviceName,
    required this.category,
    this.thumbnailImage,
    required this.keyValues,
    this.serviceDetails,
    this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
  });

  factory RecommendedService.fromJson(Map<String, dynamic> json) {
    return RecommendedService(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'],
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => KeyValueModel.fromJson(e))
          .toList(),
      serviceDetails: json['serviceDetails'] != null
          ? ServiceDetails.fromJson(json['serviceDetails'])
          : null,
      franchiseDetails: json['franchiseDetails'] != null
          ? FranchiseDetails.fromJson(json['franchiseDetails'])
          : null,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
    );
  }
}

class Category {
  final String id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class KeyValueModel {
  final String key;
  final String value;
  final String? icon;
  final String id;

  KeyValueModel({
    required this.key,
    required this.value,
    this.icon,
    required this.id,
  });

  factory KeyValueModel.fromJson(Map<String, dynamic> json) {
    return KeyValueModel(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'],
      id: json['_id'] ?? '',
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
  final int discount;
  final double discountedPrice;
  final List<String> whatYouGet;
  final String id;

  ServicePackage({
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
    required this.id,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: json['discount'] ?? 0,
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
      id: json['_id'] ?? '',
    );
  }
}

class FranchiseDetails {
  final String? commission;
  final List<InvestmentRange> investmentRange;
  final List<MonthlyEarnPotential> monthlyEarnPotential;

  FranchiseDetails({
    this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'],
      investmentRange: (json['investmentRange'] as List? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      monthlyEarnPotential: (json['monthlyEarnPotential'] as List? ?? [])
          .map((e) => MonthlyEarnPotential.fromJson(e))
          .toList(),
    );
  }
}

class InvestmentRange {
  final int minRange;
  final int maxRange;
  final String id;

  InvestmentRange({
    required this.minRange,
    required this.maxRange,
    required this.id,
  });

  factory InvestmentRange.fromJson(Map<String, dynamic> json) {
    return InvestmentRange(
      minRange: json['minRange'] ?? 0,
      maxRange: json['maxRange'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}

class MonthlyEarnPotential {
  final int minEarn;
  final int maxEarn;
  final String id;

  MonthlyEarnPotential({
    required this.minEarn,
    required this.maxEarn,
    required this.id,
  });

  factory MonthlyEarnPotential.fromJson(Map<String, dynamic> json) {
    return MonthlyEarnPotential(
      minEarn: json['minEarn'] ?? 0,
      maxEarn: json['maxEarn'] ?? 0,
      id: json['_id'] ?? '',
    );
  }
}
