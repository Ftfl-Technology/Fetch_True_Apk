class BusinessPopularServiceModel {
  final bool success;
  final int count;
  final List<BusinessPopularServiceData> data;

  BusinessPopularServiceModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory BusinessPopularServiceModel.fromJson(Map<String, dynamic> json) {
    return BusinessPopularServiceModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => BusinessPopularServiceData.fromJson(e))
          .toList(),
    );
  }
}

class BusinessPopularServiceData {
  final String serviceId;
  final String serviceName;
  final String thumbnailImage;
  final int price;
  final ServiceCategory category;
  final List<ServiceKeyValue> keyValues;
  final List<dynamic> packages;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final ServiceDetails serviceDetails;

  BusinessPopularServiceData({
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
    required this.serviceDetails,

  });

  factory BusinessPopularServiceData.fromJson(Map<String, dynamic> json) {
    return BusinessPopularServiceData(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      thumbnailImage: json['thumbnailImage'] ?? '',
      price: json['price'] ?? 0,
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      keyValues: (json['keyValues'] as List<dynamic>? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),
      packages: json['packages'] ?? [],
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      serviceDetails:
      ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
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
      investmentRange: (json['investmentRange'] as List<dynamic>? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      monthlyEarnPotential:
      (json['monthlyEarnPotential'] as List<dynamic>? ?? [])
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
