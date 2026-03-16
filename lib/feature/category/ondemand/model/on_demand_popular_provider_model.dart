class OnDemandPopularProviderModel {
  final bool success;
  final int count;
  final List<PopularProviderData> data;

  OnDemandPopularProviderModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory OnDemandPopularProviderModel.fromJson(Map<String, dynamic> json) {
    return OnDemandPopularProviderModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PopularProviderData.fromJson(e))
          .toList(),
    );
  }
}

class PopularProviderData {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final bool isStoreOpen;
  final StoreInfo storeInfo;
  final ModuleInfo module;
  final int totalReviews;
  final String providerId;
  final double averageRating;
  final List<String> categoryList;

  PopularProviderData({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.isStoreOpen,
    required this.storeInfo,
    required this.module,
    required this.totalReviews,
    required this.providerId,
    required this.averageRating,
    required this.categoryList,
  });

  factory PopularProviderData.fromJson(Map<String, dynamic> json) {
    return PopularProviderData(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      isStoreOpen: json['isStoreOpen'] ?? false,
      storeInfo: StoreInfo.fromJson(json['storeInfo'] ?? {}),
      module: ModuleInfo.fromJson(json['module'] ?? {}),
      totalReviews: json['totalReviews'] ?? 0,
      providerId: json['providerId'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      categoryList: List<String>.from(json['category_list'] ?? []),
    );
  }
}

class ModuleInfo {
  final String id;
  final String name;

  ModuleInfo({
    required this.id,
    required this.name,
  });

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final String module; // 👈 string id
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
      module: json['module'] ?? '',
      zone: json['zone'] ?? '',
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      totalProjects: json['totalProjects'] ?? 0,
      totalExperience: json['totalExperience']?.toString() ?? '',
    );
  }
}
