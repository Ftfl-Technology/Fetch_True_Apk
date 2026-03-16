class ItServiceDetailsModel {
  final String id;
  final String serviceName;
  final Category category;
  final Subcategory? subcategory;
  final double price;
  final double discount;
  final double gst;
  final bool includeGst;
  final double gstInRupees;
  final double totalWithGst;
  final double discountedPrice;
  final String thumbnailImage;
  final List<String> bannerImages;
  final List<String> tags;
  final List<KeyValue> keyValues;
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool isTrending;
  final bool isDeleted;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ItServiceDetailsModel({
    required this.id,
    required this.serviceName,
    required this.category,
    required this.subcategory,
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

  factory ItServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return ItServiceDetailsModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: json['subcategory'] != null
          ? Subcategory.fromJson(json['subcategory'])
          : null,
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      gst: (json['gst'] ?? 0).toDouble(),
      includeGst: json['includeGst'] ?? false,
      gstInRupees: (json['gstInRupees'] ?? 0).toDouble(),
      totalWithGst: (json['totalWithGst'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      thumbnailImage: json['thumbnailImage'] ?? '',
      bannerImages: List<String>.from(json['bannerImages'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => KeyValue.fromJson(e))
          .toList(),
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String module;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    module: json['module'] ?? '',
    image: json['image'] ?? '',
  );
}


class Subcategory {
  final String id;
  final String name;
  final String image;

  Subcategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    image: json['image'] ?? '',
  );
}


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

class ServiceDetails {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> highlight;
  final List<AssuredByFetchTrue> assuredByFetchTrue;
  final List<HowItWorks> howItWorks;
  final List<String> termsAndConditions; // ✅ FIX
  final List<Faq> faq;
  final List<WhyChooseUs> whyChooseUs;
  final List<Package> packages;
  final List<WeRequired> weRequired;
  final List<WeDeliver> weDeliver;
  final List<MoreInfo> moreInfo;
  final List<ConnectWith> connectWith;
  final String level;
  final int? lessonCount;
  final DurationModel duration;

  ServiceDetails({
    required this.benefits,
    required this.aboutUs,
    required this.highlight,
    required this.assuredByFetchTrue,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.faq,
    required this.whyChooseUs,
    required this.packages,
    required this.weRequired,
    required this.weDeliver,
    required this.moreInfo,
    required this.connectWith,
    required this.level,
    required this.lessonCount,
    required this.duration,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      benefits: List<String>.from(json['benefits'] ?? []),
      aboutUs: List<String>.from(json['aboutUs'] ?? []),
      highlight: List<String>.from(json['highlight'] ?? []),

      assuredByFetchTrue: (json['assuredByFetchTrue'] as List? ?? [])
          .map((e) => AssuredByFetchTrue.fromJson(e))
          .toList(),

      howItWorks: (json['howItWorks'] as List? ?? [])
          .map((e) => HowItWorks.fromJson(e))
          .toList(),

      termsAndConditions:
      List<String>.from(json['termsAndConditions'] ?? []), // ✅ FIX

      faq: (json['faq'] as List? ?? [])
          .map((e) => Faq.fromJson(e))
          .toList(),

      whyChooseUs: (json['whyChooseUs'] as List? ?? [])
          .map((e) => WhyChooseUs.fromJson(e))
          .toList(),

      packages: (json['packages'] as List? ?? [])
          .map((e) => Package.fromJson(e))
          .toList(),

      weRequired: (json['weRequired'] as List? ?? [])
          .map((e) => WeRequired.fromJson(e))
          .toList(),

      weDeliver: (json['weDeliver'] as List? ?? [])
          .map((e) => WeDeliver.fromJson(e))
          .toList(),

      moreInfo: (json['moreInfo'] as List? ?? [])
          .map((e) => MoreInfo.fromJson(e))
          .toList(),

      connectWith: (json['connectWith'] as List? ?? [])
          .map((e) => ConnectWith.fromJson(e))
          .toList(),

      level: json['level'] ?? '',
      lessonCount: json['lessonCount'],
      duration: DurationModel.fromJson(json['duration'] ?? {}),
    );
  }
}


class HowItWorks {
  final String id;
  final String title;
  final String icon;
  final String description;

  HowItWorks({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });

  factory HowItWorks.fromJson(Map<String, dynamic> json) => HowItWorks(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    icon: json['icon'] ?? '',
    description: json['description'] ?? '',
  );
}

// class WeRequired {
//   final String id;
//   final String title;
//   final String description;
//
//   WeRequired({
//     required this.id,
//     required this.title,
//     required this.description,
//   });
//
//   factory WeRequired.fromJson(Map<String, dynamic> json) => WeRequired(
//     id: json['_id'] ?? '',
//     title: json['title'] ?? '',
//     description: json['description'] ?? '',
//   );
// }

// class WeDeliver {
//   final String id;
//   final String title;
//   final String description;
//
//   WeDeliver({
//     required this.id,
//     required this.title,
//     required this.description,
//   });
//
//   factory WeDeliver.fromJson(Map<String, dynamic> json) => WeDeliver(
//     id: json['_id'] ?? '',
//     title: json['title'] ?? '',
//     description: json['description'] ?? '',
//   );
// }
class WeDeliver extends ServiceDocument {
  final String id;
  @override
  final String title;
  @override
  final String description;

  WeDeliver({
    required this.id,
    required this.title,
    required this.description,
  });

  factory WeDeliver.fromJson(Map<String, dynamic> json) => WeDeliver(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
  );
}
class WeRequired extends ServiceDocument {
  final String id;
  @override
  final String title;
  @override
  final String description;

  WeRequired({
    required this.id,
    required this.title,
    required this.description,
  });

  factory WeRequired.fromJson(Map<String, dynamic> json) => WeRequired(
    id: json['_id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
  );
}

abstract class ServiceDocument {
  String get title;
  String get description;
}


class DurationModel {
  final int? weeks;
  final int? hours;

  DurationModel({this.weeks, this.hours});

  factory DurationModel.fromJson(Map<String, dynamic> json) => DurationModel(
    weeks: json['weeks'],
    hours: json['hours'],
  );
}

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

  factory CourseCurriculum.fromJson(Map<String, dynamic> json) =>
      CourseCurriculum(
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        lists: List<String>.from(json['lists'] ?? []),
        model: List<String>.from(json['model'] ?? []),
      );
}

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

class Faq {
  final String id;
  final String question;
  final String answer;

  Faq({required this.id, required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json['_id'] ?? '',
    question: json['question'] ?? '',
    answer: json['answer'] ?? '',
  );
}

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
    discountedPrice:
    (json['discountedPrice'] ?? 0).toDouble(),
    whatYouGet:
    List<String>.from(json['whatYouGet'] ?? []),
  );
}

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

class FranchiseDetails {
  final String commission;
  final String termsAndConditions;

  FranchiseDetails({
    required this.commission,
    required this.termsAndConditions,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) =>
      FranchiseDetails(
        commission: json['commission'] ?? '',
        termsAndConditions: json['termsAndConditions'] ?? '',
      );
}
