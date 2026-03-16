class FranchiseRecommendedServiceModel {
  final bool success;
  final int count;
  final List<FranchiseRecommendedServiceData> data;

  FranchiseRecommendedServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory FranchiseRecommendedServiceModel.fromJson(Map<String, dynamic> json) {
    return FranchiseRecommendedServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => FranchiseRecommendedServiceData.fromJson(e))
          .toList(),
    );
  }
}

class FranchiseRecommendedServiceData {
  final String serviceId;
  final String serviceName;
  final String thumbnailImage;
  final int price;
  final ServiceCategory category;
  final List<ServiceKeyValue> keyValues;
  final int totalReviews;
  final double averageRating;
  final List<dynamic> packages;
  final FranchiseDetails franchiseDetails;

  FranchiseRecommendedServiceData({
    required this.serviceId,
    required this.serviceName,
    required this.thumbnailImage,
    required this.price,
    required this.category,
    required this.keyValues,
    required this.totalReviews,
    required this.averageRating,
    required this.packages,
    required this.franchiseDetails,
  });

  factory FranchiseRecommendedServiceData.fromJson(Map<String, dynamic> json) {
    return FranchiseRecommendedServiceData(
      serviceId: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? '',
      price: json['price'] ?? 0,
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      packages: json['packages'] ?? [],
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
  final String key;
  final String value;
  final String icon;

  ServiceKeyValue({
    required this.key,
    required this.value,
    required this.icon,
  });

  factory ServiceKeyValue.fromJson(Map<String, dynamic> json) {
    return ServiceKeyValue(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class FranchiseDetails {
  final String commission;
  final List<InvestmentRange> investmentRange;
  final List<InvestmentRange> monthlyEarnPotential;
  final List<FranchiseModel> franchiseModel;
  final String areaRequired;

  FranchiseDetails({
    required this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
    required this.franchiseModel,
    required this.areaRequired,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      investmentRange: (json['investmentRange'] as List? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      monthlyEarnPotential:
      (json['monthlyEarnPotential'] as List? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      franchiseModel: (json['franchiseModel'] as List? ?? [])
          .map((e) => FranchiseModel.fromJson(e))
          .toList(),
      areaRequired: json['areaRequired'] ?? '',
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

class FranchiseModel {
  final String title;
  final String agreement;
  final int price;
  final int discount;
  final int gst;
  final int fees;

  FranchiseModel({
    required this.title,
    required this.agreement,
    required this.price,
    required this.discount,
    required this.gst,
    required this.fees,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    return FranchiseModel(
      title: json['title'] ?? '',
      agreement: json['agreement'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      fees: json['fees'] ?? 0,
    );
  }
}

