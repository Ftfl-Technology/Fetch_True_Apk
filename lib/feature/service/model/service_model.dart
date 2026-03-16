class ServiceResponse {
  final bool success;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final List<ServiceModel> data;

  ServiceResponse({
    required this.success,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      success: json['success'] ?? false,
      page: json['page'] ?? 0,
      limit: json['limit'] ?? 0,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ServiceModel.fromJson(e))
          .toList(),
    );
  }
}

class ServiceModel {
  final String id;
  final String serviceName;
  final CategoryModel category;
  final SubCategoryModel? subcategory;
  final num price;
  final num discount;
  final num gst;
  final bool includeGst;
  final num gstInRupees;
  final num totalWithGst;
  final num discountedPrice;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;
  final List<KeyValueModel> keyValues;
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final num averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool isTrending;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.category,
    this.subcategory,
    required this.price,
    required this.discount,
    required this.gst,
    required this.includeGst,
    required this.gstInRupees,
    required this.totalWithGst,
    required this.discountedPrice,
    required this.thumbnailImage,
    required this.bannerImages,
    required this.tags,
    required this.keyValues,
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
    required this.isTrending,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: CategoryModel.fromJson(json['category']),
      subcategory: json['subcategory'] != null
          ? SubCategoryModel.fromJson(json['subcategory'])
          : null,
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      includeGst: json['includeGst'] ?? false,
      gstInRupees: json['gstInRupees'] ?? 0,
      totalWithGst: json['totalWithGst'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      thumbnailImage: json['thumbnailImage'] ?? '',
      bannerImages: List<String>.from(json['bannerImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      keyValues: (json['keyValues'] as List<dynamic>? ?? [])
          .map((e) => KeyValueModel.fromJson(e))
          .toList(),
      serviceDetails:
      ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      isTrending: json['isTrending'] ?? false,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String module;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.module,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      module: json['module'] ?? '',
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String image;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class KeyValueModel {
  final String value;
  final String icon;
  final String key;

  KeyValueModel({
    required this.value,
    required this.icon,
    required this.key,
  });

  factory KeyValueModel.fromJson(Map<String, dynamic> json) {
    return KeyValueModel(
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
      key: json['key'] ?? '',
    );
  }
}

class ServiceDetails {
  final List<ServicePackage> packages;
  final List<String> roi;


  ServiceDetails({
    required this.packages,
    required this.roi,

  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      packages: (json['packages'] as List<dynamic>? ?? [])
          .map((e) => ServicePackage.fromJson(e))
          .toList(),

      roi: (json['roi'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
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
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}

class FaqModel {
  final String question;
  final String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class FranchiseDetails {
  final String commission;
  final String areaRequired;
  final List<InvestmentRange> investmentRange;
  final List<MonthlyEarnPotential> monthlyEarnPotential;

  FranchiseDetails({
    required this.commission,
    required this.areaRequired,
    required this.investmentRange,
    required this.monthlyEarnPotential,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      areaRequired: json['areaRequired'] ?? '',
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





