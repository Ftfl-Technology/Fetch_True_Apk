class MostlyPopularResponse {
  bool success;
  List<MostlyPopular> data;

  MostlyPopularResponse({
    required this.success,
    required this.data,
  });

  factory MostlyPopularResponse.fromJson(Map<String, dynamic> json) {
    return MostlyPopularResponse(
      success: json['success'] ?? false,
      data: List<MostlyPopular>.from(
        (json['data'] ?? []).map((x) => MostlyPopular.fromJson(x)),
      ),
    );
  }
}

class MostlyPopular {
  String id;
  Service service;
  bool mostlyTrending;
  bool mostlyRecommended;
  bool mostlyPopular;
  int sortOrder;
  FranchiseDetails franchiseDetails;

  MostlyPopular({
    required this.id,
    required this.service,
    required this.mostlyTrending,
    required this.mostlyRecommended,
    required this.mostlyPopular,
    required this.sortOrder,
    required this.franchiseDetails,
  });

  factory MostlyPopular.fromJson(Map<String, dynamic> json) {
    return MostlyPopular(
      id: json['_id'] ?? "",
      service: Service.fromJson(json['service']),
      mostlyTrending: json['mostlyTrending'] ?? false,
      mostlyRecommended: json['mostlyRecommended'] ?? false,
      mostlyPopular: json['mostlyPopular'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
    );
  }
}

class Service {
  String id;
  String serviceName;
  String moduleName;

  Category category;
  SubCategory? subcategory;

  List<Package> packages; // ✅ ADDED
  List<KeyValue> keyValues;

  double averageRating;
  int totalReviews;
  String thumbnailImage;

  Service({
    required this.id,
    required this.serviceName,
    required this.moduleName,
    required this.category,
    this.subcategory,
    required this.packages,
    required this.keyValues,
    required this.averageRating,
    required this.totalReviews,
    required this.thumbnailImage,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? "",
      serviceName: json['serviceName'] ?? "",
      moduleName: json['moduleName'] ?? "",
      category: Category.fromJson(json['category']),
      subcategory: json['subcategory'] != null
          ? SubCategory.fromJson(json['subcategory'])
          : null,

      packages: List<Package>.from(
        (json['packages'] ?? []).map((x) => Package.fromJson(x)),
      ),

      keyValues: List<KeyValue>.from(
        (json['keyValues'] ?? []).map((x) => KeyValue.fromJson(x)),
      ),

      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      thumbnailImage: json['thumbnailImage'] ?? "",
    );
  }
}

class Package {
  String id;
  String name;
  double price;
  double discount;
  double discountedPrice;
  List<String> whatYouGet;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}

class Category {
  String id;
  String name;
  String image;
  Module module;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.module,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      module: Module.fromJson(json['module']),
    );
  }
}

class Module {
  String id;
  String name;

  Module({
    required this.id,
    required this.name,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
    );
  }
}

class SubCategory {
  String id;
  String name;
  String image;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
    );
  }
}

class KeyValue {
  String id;
  String key;
  String value;
  String icon;

  KeyValue({
    required this.id,
    required this.key,
    required this.value,
    required this.icon,
  });

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      id: json['_id'] ?? "",
      key: json['key'] ?? "",
      value: json['value'] ?? "",
      icon: json['icon'] ?? "",
    );
  }
}

class FranchiseDetails {
  String commission;
  String? areaRequired;
  InvestmentRange? investmentRange;
  InvestmentRange? monthlyEarnPotential;
  FranchiseModel? franchiseModel;

  FranchiseDetails({
    required this.commission,
    this.areaRequired,
    this.investmentRange,
    this.monthlyEarnPotential,
    this.franchiseModel,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? "",
      areaRequired: json['areaRequired']?.toString(),
      investmentRange: json['investmentRange'] != null
          ? InvestmentRange.fromJson(json['investmentRange'])
          : null,
      monthlyEarnPotential: json['monthlyEarnPotential'] != null
          ? InvestmentRange.fromJson(json['monthlyEarnPotential'])
          : null,
      franchiseModel: json['franchiseModel'] != null
          ? FranchiseModel.fromJson(json['franchiseModel'])
          : null,
    );
  }
}

class InvestmentRange {
  String id;
  String range;
  String parameters;

  InvestmentRange({
    required this.id,
    required this.range,
    required this.parameters,
  });

  factory InvestmentRange.fromJson(Map<String, dynamic> json) {
    return InvestmentRange(
      id: json['_id'] ?? "",
      range: json['range'] ?? "",
      parameters: json['parameters'] ?? "",
    );
  }
}

class FranchiseModel {
  String id;
  String title;
  String agreement;
  int price;
  int discount;
  int gst;
  int fees;

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
      id: json['_id'] ?? "",
      title: json['title'] ?? "",
      agreement: json['agreement'] ?? "",
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      fees: json['fees'] ?? 0,
    );
  }
}
