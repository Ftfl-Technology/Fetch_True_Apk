// ================= MAIN MODEL =================
class EducationServiceDetailsModel {
  final String id;
  final String serviceName;
  final Category category;
  final Subcategory subCategory;
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
  final List<KeyValue> keyValues;
  final ServiceDetailsData serviceDetails;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool isTrending;
  final bool isDeleted;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  EducationServiceDetailsModel({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.subCategory,
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
    required this.isDeleted,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EducationServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return EducationServiceDetailsModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      subCategory: Subcategory.fromJson(json['subcategory'] ?? {}),
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      includeGst: json['includeGst'] ?? true,
      gstInRupees: json['gstInRupees'] ?? 0,
      totalWithGst: json['totalWithGst'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      thumbnailImage: json['thumbnailImage'] ?? '',
      bannerImages: List<String>.from(json['bannerImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => KeyValue.fromJson(e))
          .toList(),
      serviceDetails: ServiceDetailsData.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// ================= CATEGORY =================
class Category {
  final String id;
  final String name;
  final String module;
  final String image;
  final bool isDeleted;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
    required this.isDeleted,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      module: json['module'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// ================= SUBCATEGORY =================
class Subcategory {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final String category;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subcategory({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.category,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      category: json['category'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

// ================= KEYVALUE =================
class KeyValue {
  final String id;
  final String value;
  final String icon;

  KeyValue({required this.id, required this.value, required this.icon});

  factory KeyValue.fromJson(Map<String, dynamic> json) => KeyValue(
    id: json['_id'] ?? '',
    value: json['value'] ?? '',
    icon: json['icon'] ?? '',
  );
}

// ================= SERVICE DETAILS =================
class ServiceDetailsData {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> highlight;
  final List<AssuredByFetchTrue> assuredByFetchTrue;
  final List<String> termsAndConditions;
  final List<FaqModel> faq;
  final List<WhyChooseUs> whyChooseUs;
  final List<Package> packages;
  final List<MoreInfo> moreInfo;
  final List<ConnectWith> connectWith;
  final List<String> emiAvailable;
  final String level;
  final int lessonCount;
  final DurationModel duration;
  final List<String> whatYouWillLearn;
  final List<String> eligibleFor;
  final List<CourseCurriculum> courseCurriculum;
  final List<String> courseIncludes;
  final List<String> certificateImage;

  ServiceDetailsData({
    required this.benefits,
    required this.aboutUs,
    required this.highlight,
    required this.assuredByFetchTrue,
    required this.termsAndConditions,
    required this.faq,
    required this.whyChooseUs,
    required this.packages,
    required this.moreInfo,
    required this.connectWith,
    required this.emiAvailable,
    required this.level,
    required this.lessonCount,
    required this.duration,
    required this.whatYouWillLearn,
    required this.eligibleFor,
    required this.courseCurriculum,
    required this.courseIncludes,
    required this.certificateImage,
  });

  factory ServiceDetailsData.fromJson(Map<String, dynamic> json) {
    return ServiceDetailsData(
      benefits: List<String>.from(json['benefits'] ?? []),
      aboutUs: List<String>.from(json['aboutUs'] ?? []),
      highlight: List<String>.from(json['highlight'] ?? []),
      assuredByFetchTrue: (json['assuredByFetchTrue'] as List? ?? [])
          .map((e) => AssuredByFetchTrue.fromJson(e))
          .toList(),
      termsAndConditions: List<String>.from(json['termsAndConditions'] ?? []),
      faq: (json['faq'] as List? ?? [])
          .map((e) => FaqModel.fromJson(e))
          .toList(),
      whyChooseUs: (json['whyChooseUs'] as List? ?? [])
          .map((e) => WhyChooseUs.fromJson(e))
          .toList(),
      packages: (json['packages'] as List? ?? [])
          .map((e) => Package.fromJson(e))
          .toList(),
      moreInfo: (json['moreInfo'] as List? ?? [])
          .map((e) => MoreInfo.fromJson(e))
          .toList(),
      connectWith: (json['connectWith'] as List? ?? [])
          .map((e) => ConnectWith.fromJson(e))
          .toList(),
      emiAvailable: List<String>.from(json['emiavalable'] ?? []),
      level: json['level'] ?? '',
      lessonCount: json['lessonCount'] ?? 0,
      duration: DurationModel.fromJson(json['duration'] ?? {}),
      whatYouWillLearn: List<String>.from(json['whatYouWillLearn'] ?? []),
      eligibleFor: List<String>.from(json['eligibleFor'] ?? []),
      courseCurriculum: (json['courseCurriculum'] as List? ?? [])
          .map((e) => CourseCurriculum.fromJson(e))
          .toList(),
      courseIncludes: List<String>.from(json['courseIncludes'] ?? []),
      certificateImage: List<String>.from(json['certificateImage'] ?? []),
    );
  }
}

// ================= ASSURED BY FETCH TRUE =================
class AssuredByFetchTrue {
  final String id;
  final String title;
  final String icon;
  final String description;

  AssuredByFetchTrue({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });

  factory AssuredByFetchTrue.fromJson(Map<String, dynamic> json) =>
      AssuredByFetchTrue(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        icon: json['icon'] ?? '',
        description: json['description'] ?? '',
      );
}

// ================= FAQ =================
class FaqModel {
  final String id;
  final String question;
  final String answer;

  FaqModel({required this.id, required this.question, required this.answer});

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    id: json['_id'] ?? '',
    question: json['question'] ?? '',
    answer: json['answer'] ?? '',
  );
}

// ================= WHY CHOOSE US =================
class WhyChooseUs {
  final String id;
  final String title;
  final String icon;
  final String description;

  WhyChooseUs({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });

  factory WhyChooseUs.fromJson(Map<String, dynamic> json) => WhyChooseUs(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    icon: json['icon'] ?? '',
    description: json['description'] ?? '',
  );
}

// ================= PACKAGE =================
class Package {
  final String id;
  final String name;
  final double price;
  final double discount;
  final double discountedPrice;
  final List<String> whatYouGet;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    discount: (json['discount'] ?? 0).toDouble(),
    discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
    whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
  );
}

// ================= MORE INFO =================
class MoreInfo {
  final String id;
  final String title;
  final String image;
  final String description;

  MoreInfo({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
  });

  factory MoreInfo.fromJson(Map<String, dynamic> json) => MoreInfo(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    image: json['image'] ?? '',
    description: json['description'] ?? '',
  );
}

// ================= CONNECT WITH =================
class ConnectWith {
  final String id;
  final String name;
  final String mobileNo;
  final String email;

  ConnectWith({
    required this.id,
    required this.name,
    required this.mobileNo,
    required this.email,
  });

  factory ConnectWith.fromJson(Map<String, dynamic> json) => ConnectWith(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    mobileNo: json['mobileNo'] ?? '',
    email: json['email'] ?? '',
  );
}

// ================= DURATION MODEL =================
class DurationModel {
  final int? weeks;
  final int? hours;

  DurationModel({this.weeks, this.hours});

  factory DurationModel.fromJson(Map<String, dynamic> json) => DurationModel(
    weeks: json['weeks'],
    hours: json['hours'],
  );
}

// ================= COURSE CURRICULUM =================
class CourseCurriculum {
  final String id;
  final String title;
  final List<String> lists;
  final List<String> model;

  CourseCurriculum({
    required this.id,
    required this.title,
    required this.lists,
    required this.model,
  });

  factory CourseCurriculum.fromJson(Map<String, dynamic> json) => CourseCurriculum(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    lists: List<String>.from(json['lists'] ?? []),
    model: List<String>.from(json['model'] ?? []),
  );
}

// ================= FRANCHISE DETAILS =================
class FranchiseDetails {
  final String commission;
  final String termsAndConditions;

  FranchiseDetails({required this.commission, required this.termsAndConditions});

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) => FranchiseDetails(
    commission: json['commission'] ?? '',
    termsAndConditions: json['termsAndConditions'] ?? '',
  );
}
