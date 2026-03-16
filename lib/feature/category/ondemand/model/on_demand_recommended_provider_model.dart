class OnDemandRecommendedProviderModel {
  final List<RecommendedProviderData> data;

  OnDemandRecommendedProviderModel({required this.data});

  factory OnDemandRecommendedProviderModel.fromJson(List<dynamic> json) {
    return OnDemandRecommendedProviderModel(
      data: json
          .map((e) => RecommendedProviderData.fromJson(e))
          .toList(),
    );
  }
}

class RecommendedProviderData {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final double averageRating;
  final int totalReviews;
  final bool isStoreOpen;
  final List<String> categoryList;
  final StoreInfo storeInfo;

  RecommendedProviderData({
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

  factory RecommendedProviderData.fromJson(Map<String, dynamic> json) {
    return RecommendedProviderData(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      isStoreOpen: json['isStoreOpen'] ?? false,
      categoryList: List<String>.from(json['category_list'] ?? []),
      storeInfo: StoreInfo.fromJson(json['storeInfo'] ?? {}),
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final StoreModule module;
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
      module: StoreModule.fromJson(json['module'] ?? {}),
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

class StoreModule {
  final String id;
  final String name;

  StoreModule({
    required this.id,
    required this.name,
  });

  factory StoreModule.fromJson(Map<String, dynamic> json) {
    return StoreModule(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
