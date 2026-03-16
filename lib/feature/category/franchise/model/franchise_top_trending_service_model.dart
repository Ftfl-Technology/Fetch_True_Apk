class FranchiseTopTrendingServiceModel {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<FranchiseTopTrendingServiceData> data;

  FranchiseTopTrendingServiceModel({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory FranchiseTopTrendingServiceModel.fromJson(Map<String, dynamic> json) {
    return FranchiseTopTrendingServiceModel(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => FranchiseTopTrendingServiceData.fromJson(e))
          .toList(),
    );
  }
}

class FranchiseTopTrendingServiceData {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final String thumbnailImage;
  final List<ServiceKeyValue> keyValues;
  final ServiceDetails? serviceDetails;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool isTrending;

  FranchiseTopTrendingServiceData({
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

  factory FranchiseTopTrendingServiceData.fromJson(Map<String, dynamic> json) {
    return FranchiseTopTrendingServiceData(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category'] ?? {}),
      thumbnailImage: json['thumbnailImage'] ?? '',
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => ServiceKeyValue.fromJson(e))
          .toList(),
      serviceDetails: json['serviceDetails'] != null
          ? ServiceDetails.fromJson(json['serviceDetails'])
          : null,
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
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
      packages: (json['packages'] as List? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),
    );
  }
}

class ServicePackage {
  final String name;
  final int price;
  final int discount;
  final double discountedPrice;
  final List<String> whatYouGet;

  ServicePackage({
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
  });

  factory ServicePackage.fromJson(Map<String, dynamic> json) {
    return ServicePackage(
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: (json['whatYouGet'] as List? ?? []).cast<String>(),
    );
  }
}

class FranchiseDetails {
  final String commission;
  final List<RangeModel> investmentRange;
  final List<RangeModel> monthlyEarnPotential;
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
          .map((e) => RangeModel.fromJson(e))
          .toList(),
      monthlyEarnPotential:
      (json['monthlyEarnPotential'] as List? ?? [])
          .map((e) => RangeModel.fromJson(e))
          .toList(),
      franchiseModel: (json['franchiseModel'] as List? ?? [])
          .map((e) => FranchiseModel.fromJson(e))
          .toList(),
    );
  }
}

class RangeModel {
  final String id;
  final String range;
  final String parameters;

  RangeModel({
    required this.id,
    required this.range,
    required this.parameters,
  });

  factory RangeModel.fromJson(Map<String, dynamic> json) {
    return RangeModel(
      id: json['_id'] ?? '',
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
      investmentRange:
      (json['investmentRange'] as List<dynamic>? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),
      monthlyEarnPotential:
      (json['monthlyEarnPotential'] as List<dynamic>? ?? [])
          .map((e) => MonthlyEarnPotential.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commission': commission,
      'investmentRange':
      investmentRange.map((e) => e.toJson()).toList(),
      'monthlyEarnPotential':
      monthlyEarnPotential.map((e) => e.toJson()).toList(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'minRange': minRange,
      'maxRange': maxRange,
      '_id': id,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'minEarn': minEarn,
      'maxEarn': maxEarn,
      '_id': id,
    };
  }
}
