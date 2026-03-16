class BusinessRecommendedServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<BusinessRecommendedServiceData> data;

  BusinessRecommendedServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory BusinessRecommendedServiceModel.fromJson(Map<String, dynamic> json) {
    return BusinessRecommendedServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BusinessRecommendedServiceData.fromJson(e))
          .toList(),
    );
  }
}

class BusinessRecommendedServiceData {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final String thumbnailImage;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final ServiceDetails serviceDetails;


  BusinessRecommendedServiceData({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.thumbnailImage,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
    required this.serviceDetails,

  });

  factory BusinessRecommendedServiceData.fromJson(Map<String, dynamic> json) {
    return BusinessRecommendedServiceData(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
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

class FranchiseDetails {
  final String commission;
  final List<InvestmentRange> investmentRange;
  final List<MonthlyEarnPotential> monthlyEarnPotential;
  final List<FranchiseModel> franchiseModel;

  FranchiseDetails({
    required this.commission,
    required this.investmentRange,
    required this.monthlyEarnPotential,
    required this.franchiseModel,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      investmentRange: (json['investmentRange'] as List? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      monthlyEarnPotential: (json['monthlyEarnPotential'] as List? ?? [])
          .map((e) => MonthlyEarnPotential.fromJson(e))
          .toList(),
      franchiseModel: (json['franchiseModel'] as List? ?? [])
          .map((e) => FranchiseModel.fromJson(e))
          .toList(),
    );
  }
}

class FranchiseModel {
  final String id;
  final String title;
  final String agreement;
  final num price;
  final num discount;
  final num gst;
  final num fees;

  FranchiseModel({
    required this.id,
    required this.title,
    required this.agreement,
    required this.price,
    required this.discount,
    required this.gst,
    required this.fees,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    return FranchiseModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      agreement: json['agreement'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      fees: json['fees'] ?? 0,
    );
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