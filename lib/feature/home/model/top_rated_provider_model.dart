class TopRatedProviderModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final double averageRating;
  final int totalReviews;
  final bool isStoreOpen;
  final List<String> categoryList;
  final StoreInfo storeInfo;

  TopRatedProviderModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.averageRating,
    required this.totalReviews,
    required this.isStoreOpen,
    required this.categoryList,
    required this.storeInfo,
  });

  factory TopRatedProviderModel.fromJson(Map<String, dynamic> json) {
    return TopRatedProviderModel(
      id: json['_id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isStoreOpen: json['isStoreOpen'] ?? false,
      categoryList: (json['category_list'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      storeInfo: StoreInfo.fromJson(json['storeInfo'] ?? {}),
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final Module module;
  final String zone;
  final String logo;
  final String cover;
  final String address;
  final String city;
  final String state;
  final String country;
  final String aboutUs;
  final List<String> tags;
  final int totalProjects;
  final String totalExperience;

  StoreInfo({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    required this.module,
    required this.zone,
    required this.logo,
    required this.cover,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.aboutUs,
    required this.tags,
    required this.totalProjects,
    required this.totalExperience,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeName: json['storeName'] ?? '',
      storePhone: json['storePhone'] ?? '',
      storeEmail: json['storeEmail'] ?? '',
      module: Module.fromJson(json['module'] ?? {}),
      zone: json['zone'] ?? '',
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      totalProjects: json['totalProjects'] ?? 0,
      totalExperience: json['totalExperience']?.toString() ?? '0',
    );
  }
}

class Module {
  final String id;
  final String name;

  Module({
    required this.id,
    required this.name,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['_id'],
      name: json['name'],
    );
  }
}
