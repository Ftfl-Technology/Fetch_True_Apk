class BusinessTopTrendingServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<BusinessTopTrendingServiceData> data;

  BusinessTopTrendingServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory BusinessTopTrendingServiceModel.fromJson(Map<String, dynamic> json) {
    return BusinessTopTrendingServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BusinessTopTrendingServiceData.fromJson(e))
          .toList(),
    );
  }
}

class BusinessTopTrendingServiceData {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final String thumbnailImage;
  final FranchiseTrendingDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool isTrending;
  final ServiceDetails serviceDetails;

  BusinessTopTrendingServiceData({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.thumbnailImage,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.isTrending,
    required this.serviceDetails,

  });

  factory BusinessTopTrendingServiceData.fromJson(Map<String, dynamic> json) {
    return BusinessTopTrendingServiceData(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',
      franchiseDetails:
      FranchiseTrendingDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isTrending: json['isTrending'] ?? false,
      serviceDetails:
      ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
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

  ServiceKeyValue({
    required this.id,
    required this.key,
    required this.value,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      id: json['_id'] ?? '',
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'key': key,
      'value': value,
    };
  }
}

class ServiceDetails {
  final List<String> roi;

  ServiceDetails({
    required this.roi,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      roi: (json['roi'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}


class FranchiseTrendingDetails {
  final String commission;
  final List<InvestmentRange> investmentRange;
  final List<MonthlyEarnPotential> monthlyEarnPotential;

  FranchiseTrendingDetails({
    required this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
  });

  factory FranchiseTrendingDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseTrendingDetails(
      commission: json['commission'] ?? '',
      investmentRange: (json['investmentRange'] as List<dynamic>? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      monthlyEarnPotential:
      (json['monthlyEarnPotential'] as List<dynamic>? ?? [])
          .map((e) => MonthlyEarnPotential.fromJson(e))
          .toList(),
    );
  }
}

class InvestmentRange {
  final String range;
  final String parameters;

  InvestmentRange({
    required this.range,
    required this.parameters,
  });

  factory InvestmentRange.fromJson(Map<String, dynamic> json) {
    return InvestmentRange(
      range: json['range'] ?? '',
      parameters: json['parameters'] ?? '',
    );
  }
}

class MonthlyEarnPotential {
  final String range;
  final String parameters;

  MonthlyEarnPotential({
    required this.range,
    required this.parameters,
  });

  factory MonthlyEarnPotential.fromJson(Map<String, dynamic> json) {
    return MonthlyEarnPotential(
      range: json['range'] ?? '',
      parameters: json['parameters'] ?? '',
    );
  }
}
