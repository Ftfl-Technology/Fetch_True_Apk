class ServiceWiseProviderSubscriberResponse {
  final bool success;
  final int count;
  final List<ProviderSubscriberModel> data;

  ServiceWiseProviderSubscriberResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ServiceWiseProviderSubscriberResponse.fromJson(Map<String, dynamic> json) {
    return ServiceWiseProviderSubscriberResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List? ?? [])
          .map((e) => ProviderSubscriberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProviderSubscriberModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;
  final List<String> galleryImages;
  final List<SubscribedServiceModel> subscribedServices;
  final double averageRating;
  final int totalReviews;
  final String providerId;
  final bool isStoreOpen;
  final bool? isPromoted;
  final StoreInfoModel storeInfo;

  ProviderSubscriberModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.galleryImages,
    required this.subscribedServices,
    required this.averageRating,
    required this.totalReviews,
    required this.providerId,
    required this.isStoreOpen,
    this.isPromoted,
    required this.storeInfo,
  });

  factory ProviderSubscriberModel.fromJson(Map<String, dynamic> json) {
    return ProviderSubscriberModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',
      galleryImages: (json['galleryImages'] as List? ?? []).map((e) => e.toString()).toList(),
      subscribedServices: (json['subscribedServices'] as List? ?? [])
          .map((e) => SubscribedServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] is int
          ? json['totalReviews']
          : int.tryParse(json['totalReviews'].toString()) ?? 0,
      providerId: json['providerId'] ?? '',
      isStoreOpen: json['isStoreOpen'] ?? true,
      isPromoted: json['isPromoted'],
      storeInfo: StoreInfoModel.fromJson(json['storeInfo'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class SubscribedServiceModel {
  final String id;
  final String serviceName;

  SubscribedServiceModel({
    required this.id,
    required this.serviceName,
  });

  factory SubscribedServiceModel.fromJson(Map<String, dynamic> json) {
    return SubscribedServiceModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
    );
  }
}

class StoreInfoModel {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final String address;
  final String city;
  final String state;
  final String country;
  final ZoneModel zone;
  final String? logo;
  final String? cover;
  final List<String>? tags;
  final int? totalProjects;
  final int? totalExperience;

  StoreInfoModel({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.zone,
    this.logo,
    this.cover,
    this.tags,
    this.totalProjects,
    this.totalExperience,
  });

  factory StoreInfoModel.fromJson(Map<String, dynamic> json) {
    return StoreInfoModel(
      storeName: json['storeName'] ?? '',
      storePhone: json['storePhone'] ?? '',
      storeEmail: json['storeEmail'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      zone: ZoneModel.fromJson(json['zone'] as Map<String, dynamic>? ?? {}),
      logo: json['logo']?.toString(),
      cover: json['cover']?.toString(),
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      totalProjects: json['totalProjects'] is int
          ? json['totalProjects']
          : int.tryParse(json['totalProjects']?.toString() ?? ''),
      totalExperience: json['totalExperience'] is int
          ? json['totalExperience']
          : int.tryParse(json['totalExperience']?.toString() ?? ''),
    );
  }
}

class ZoneModel {
  final String id;
  final String name;

  ZoneModel({
    required this.id,
    required this.name,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

