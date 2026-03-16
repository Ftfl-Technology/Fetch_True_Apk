class ProviderModel {
  final String id;
  final String fullName;
  final String phoneNo;
  final String email;

  final List<String> galleryImages;
  final List<SubscribedService> subscribedServices;

  final double averageRating;
  final int totalReviews;

  final bool isRejected;
  final bool isApproved;
  final bool isVerified;
  final bool isDeleted;
  final bool isStoreOpen;
  final bool isRecommended;
  final bool isTrending;

  final bool step1Completed;
  final bool storeInfoCompleted;
  final bool kycCompleted;

  final String registrationStatus;
  final String providerId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final StoreInfo? storeInfo;
  final KycInfo? kyc;

  // ✅ Added missing fields
  final bool? isPromoted;
  final bool? topRated;

  ProviderModel({
    required this.id,
    required this.fullName,
    required this.phoneNo,
    required this.email,
    required this.galleryImages,
    required this.subscribedServices,
    required this.averageRating,
    required this.totalReviews,
    required this.isRejected,
    required this.isApproved,
    required this.isVerified,
    required this.isDeleted,
    required this.isStoreOpen,
    required this.isRecommended,
    required this.isTrending,
    required this.step1Completed,
    required this.storeInfoCompleted,
    required this.kycCompleted,
    required this.registrationStatus,
    required this.providerId,
    this.createdAt,
    this.updatedAt,
    this.storeInfo,
    this.kyc,
    this.isPromoted,
    this.topRated,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      email: json['email'] ?? '',

      galleryImages: List<String>.from(json['galleryImages'] ?? []),

      subscribedServices: (json['subscribedServices'] as List? ?? [])
          .map((e) => SubscribedService.fromJson(e))
          .toList(),

      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,

      isRejected: json['isRejected'] ?? false,
      isApproved: json['isApproved'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isStoreOpen: json['isStoreOpen'] ?? false,
      isRecommended: json['isRecommended'] ?? false,
      isTrending: json['isTrending'] ?? false,

      step1Completed: json['step1Completed'] ?? false,
      storeInfoCompleted: json['storeInfoCompleted'] ?? false,
      kycCompleted: json['kycCompleted'] ?? false,

      registrationStatus: json['registrationStatus'] ?? '',
      providerId: json['providerId'] ?? '',

      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,

      storeInfo: json['storeInfo'] != null
          ? StoreInfo.fromJson(json['storeInfo'])
          : null,

      kyc: json['kyc'] != null ? KycInfo.fromJson(json['kyc']) : null,

      // ✅ Parse new fields
      isPromoted: json['isPromoted'],
      topRated: json['topRated'],
    );
  }
}

class StoreInfo {
  final String storeName;
  final String storePhone;
  final String storeEmail;
  final ModuleInfo? module;
  final String zone;
  final String logo;
  final String cover;
  final String address;
  final String city;
  final String state;
  final String country;
  final String? aboutUs;
  final List<String> tags;

  // ✅ Added missing fields
  final int? totalProjects;
  final String? totalExperience;

  StoreInfo({
    required this.storeName,
    required this.storePhone,
    required this.storeEmail,
    this.module,
    required this.zone,
    required this.logo,
    required this.cover,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    this.aboutUs,
    required this.tags,
    this.totalProjects,
    this.totalExperience,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    ModuleInfo? module;

    if (json['module'] != null) {
      if (json['module'] is Map<String, dynamic>) {
        module = ModuleInfo.fromJson(json['module']);
      } else {
        module = ModuleInfo(
          id: json['module'].toString(),
          name: json['moduleName'] ?? 'Unknown',
        );
      }
    }

    return StoreInfo(
      storeName: json['storeName'] ?? '',
      storePhone: json['storePhone'] ?? '',
      storeEmail: json['storeEmail'] ?? '',
      module: module,
      zone: json['zone'] ?? '',
      logo: json['logo'] ?? '',
      cover: json['cover'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      aboutUs: json['aboutUs'],
      tags: List<String>.from(json['tags'] ?? []),

      // ✅ Parse new fields
      totalProjects: json['totalProjects'],
      totalExperience: json['totalExperience'],
    );
  }
}

class ModuleInfo {
  final String id;
  final String name;

  ModuleInfo({required this.id, required this.name});

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }
}

class KycInfo {
  final List<String> aadhaarCard;
  final List<String> panCard;
  final List<String> storeDocument;
  final List<String> gst;
  final List<String> other;

  KycInfo({
    required this.aadhaarCard,
    required this.panCard,
    required this.storeDocument,
    required this.gst,
    required this.other,
  });

  factory KycInfo.fromJson(Map<String, dynamic> json) {
    return KycInfo(
      aadhaarCard: List<String>.from(json['aadhaarCard'] ?? []),
      panCard: List<String>.from(json['panCard'] ?? []),
      storeDocument: List<String>.from(json['storeDocument'] ?? []),
      gst: List<String>.from(json['GST'] ?? []),
      other: List<String>.from(json['other'] ?? []),
    );
  }
}

class SubscribedService {
  final String id;
  final String serviceName;
  final ServiceCategory category;
  final int price;
  final int discountedPrice;
  final bool isDeleted;

  SubscribedService({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.price,
    required this.discountedPrice,
    required this.isDeleted,
  });

  factory SubscribedService.fromJson(Map<String, dynamic> json) {
    return SubscribedService(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: ServiceCategory.fromJson(json['category']),
      price: json['price'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}

class ServiceCategory {
  final String id;
  final String name;

  ServiceCategory({required this.id, required this.name});

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}