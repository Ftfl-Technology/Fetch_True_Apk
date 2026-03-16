class ProviderSubscribeServiceModel {
  final bool success;
  final List<SubscribedService> data;

  ProviderSubscribeServiceModel({
    required this.success,
    required this.data,
  });

  factory ProviderSubscribeServiceModel.fromJson(Map<String, dynamic> json) {
    return ProviderSubscribeServiceModel(
      success: json['success'] ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => SubscribedService.fromJson(e))
          .toList(),
    );
  }
}

class SubscribedService {
  final int srNo;
  final String id;
  final String serviceName;
  final CategoryModel? category;
  final double price;
  final double discount;
  final double gst;
  final bool includeGst;
  final double totalWithGst;
  final double discountedPrice;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;
  final List<KeyValueModel> keyValues;
  final ServiceDetailsModel? serviceDetails;
  final FranchiseDetailsModel? franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final String categoryName;
  final String status;

  SubscribedService({
    required this.srNo,
    required this.id,
    required this.serviceName,
    this.category,
    required this.price,
    required this.discount,
    required this.gst,
    required this.includeGst,
    required this.totalWithGst,
    required this.discountedPrice,
    required this.thumbnailImage,
    required this.bannerImages,
    required this.tags,
    required this.keyValues,
    this.serviceDetails,
    this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.categoryName,
    required this.status,
  });

  factory SubscribedService.fromJson(Map<String, dynamic> json) {
    return SubscribedService(
      srNo: json['srNo'] ?? 0,
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',

      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,

      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      gst: (json['gst'] ?? 0).toDouble(),
      includeGst: json['includeGst'] ?? false,
      totalWithGst: (json['totalWithGst'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),

      thumbnailImage: json['thumbnailImage'] ?? '',

      bannerImages: List<String>.from(json['bannerImages'] ?? []),

      tags: List<String>.from(json['tags'] ?? []),

      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => KeyValueModel.fromJson(e))
          .toList(),

      serviceDetails: json['serviceDetails'] != null
          ? ServiceDetailsModel.fromJson(json['serviceDetails'])
          : null,

      franchiseDetails: json['franchiseDetails'] != null
          ? FranchiseDetailsModel.fromJson(json['franchiseDetails'])
          : null,

      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,

      categoryName: json['categoryName'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String module;
  final int sortOrder;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.module,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      module: json['module'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class KeyValueModel {
  final String id;
  final String value;
  final String icon;

  KeyValueModel({
    required this.id,
    required this.value,
    required this.icon,
  });

  factory KeyValueModel.fromJson(Map<String, dynamic> json) {
    return KeyValueModel(
      id: json['_id'] ?? '',
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class ServiceDetailsModel {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> termsAndConditions;
  final List<PackageModel> packages;

  ServiceDetailsModel({
    required this.benefits,
    required this.aboutUs,
    required this.termsAndConditions,
    required this.packages,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsModel(
      benefits: List<String>.from(json['benefits'] ?? []),
      aboutUs: List<String>.from(json['aboutUs'] ?? []),
      termsAndConditions:
      List<String>.from(json['termsAndConditions'] ?? []),

      packages: (json['packages'] as List? ?? [])
          .map((e) => PackageModel.fromJson(e))
          .toList(),
    );
  }
}

class FranchiseDetailsModel {
  final String commission;
  final String termsAndConditions;

  FranchiseDetailsModel({
    required this.commission,
    required this.termsAndConditions,
  });

  factory FranchiseDetailsModel.fromJson(Map<String, dynamic> json) {
    return FranchiseDetailsModel(
      commission: json['commission'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
    );
  }
}

class PackageModel {
  final String id;
  final String name;
  final double price;
  final double discount;       // changed num → double
  final double discountedPrice;
  final String duration;
  final List<String> features;
  final bool isPopular;

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.duration,
    required this.features,
    required this.isPopular,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      duration: json['duration'] ?? '',
      features: List<String>.from(json['whatYouGet'] ?? []), // JSON me usually 'whatYouGet'
      isPopular: json['isPopular'] ?? false,
    );
  }
}





