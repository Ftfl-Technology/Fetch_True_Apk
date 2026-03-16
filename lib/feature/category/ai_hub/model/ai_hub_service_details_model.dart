
class AiHubServiceDetailsModel {
  final String id;
  final String serviceName;
  final Category category;
  final SubCategory subcategory;

  final int price;
  final int discount;
  final int gst;
  final bool includeGst;
  final int gstInRupees;
  final int totalWithGst;
  final int discountedPrice;

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

  AiHubServiceDetailsModel({
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
  });

  factory AiHubServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return AiHubServiceDetailsModel(
      id: json['_id'],
      serviceName: json['serviceName'],
      category: Category.fromJson(json['category']),
      subcategory: SubCategory.fromJson(json['subcategory']),
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
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => KeyValue.fromJson(e))
          .toList(),
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails']),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails']),
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      isTrending: json['isTrending'] ?? false,
    );
  }
}


class Category {
  final String id;
  final String name;
  final String image;

  Category({required this.id, required this.name, required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String image;

  SubCategory({required this.id, required this.name, required this.image});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class KeyValue {
  final String key;
  final String value;
  final String icon;

  KeyValue({required this.key, required this.value, required this.icon});

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(
      key: json['key'] ?? '',
      icon: json['icon'] ?? '',
      value: json['value'] ?? '',
    );
  }
}

class ServiceDetails {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> highlight;

  final List<AssuredByFetchTrue> assuredByFetchTrue;
  final List<HowItWorks> howItWorks;
  final List<String> termsAndConditions;
  final List<Faq> faq;
  final List<WhyChooseUs> whyChooseUs;

  final List<PackageModel> packages;
  final List<WeItem> weRequired;
  final List<WeItem> weDeliver;
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
      List<String>.from(json['termsAndConditions'] ?? []),
      faq: (json['faq'] as List? ?? [])
          .map((e) => Faq.fromJson(e))
          .toList(),
      whyChooseUs: (json['whyChooseUs'] as List? ?? [])
          .map((e) => WhyChooseUs.fromJson(e))
          .toList(),
      packages: (json['packages'] as List? ?? [])
          .map((e) => PackageModel.fromJson(e))
          .toList(),
      weRequired: (json['weRequired'] as List? ?? [])
          .map((e) => WeItem.fromJson(e))
          .toList(),
      weDeliver: (json['weDeliver'] as List? ?? [])
          .map((e) => WeItem.fromJson(e))
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
  final String title;
  final String description;
  final String? icon; // agar future me icon/image aaye

  HowItWorks({
    required this.title,
    required this.description,
    this.icon,
  });

  factory HowItWorks.fromJson(Map<String, dynamic> json) {
    return HowItWorks(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'], // optional
    );
  }
}


class PackageModel {
  final String name;
  final int price;
  final int discount;
  final double discountedPrice;
  final List<String> whatYouGet;

  PackageModel({
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      name: json['name'],
      price: json['price'],
      discount: json['discount'],
      discountedPrice:
      (json['discountedPrice'] ?? 0).toDouble(),
      whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
    );
  }
}


class DurationModel {
  final int? weeks;
  final int? hours;

  DurationModel({this.weeks, this.hours});

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      weeks: json['weeks'],
      hours: json['hours'],
    );
  }
}

class CompleteSupportSystem {
  final String icon;
  final String title;
  final List<String> lists;

  CompleteSupportSystem({
    required this.icon,
    required this.title,
    required this.lists,
  });

  factory CompleteSupportSystem.fromJson(Map<String, dynamic> json) {
    return CompleteSupportSystem(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      lists: List<String>.from(json['lists'] ?? []),
    );
  }
}

class AssuredByFetchTrue {
  final String title;
  final String icon;
  final String description;

  AssuredByFetchTrue({
    required this.title,
    required this.icon,
    required this.description,
  });

  factory AssuredByFetchTrue.fromJson(Map<String, dynamic> json) {
    return AssuredByFetchTrue(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',

    );
  }
}

class WhyChooseUs {
  final String title;
  final String icon;
  final String description;

  WhyChooseUs({
    required this.title,
    required this.icon,
    required this.description,
  });

  factory WhyChooseUs.fromJson(Map<String, dynamic> json) {
    return WhyChooseUs(
      title: json['title'],
      icon: json['icon'],
      description: json['description'],
    );
  }
}

class WeItem {
  final String title;
  final String description;

  WeItem({
    required this.title,
    required this.description,
  });

  factory WeItem.fromJson(Map<String, dynamic> json) {
    return WeItem(
      title: json['title'],
      description: json['description'],
    );
  }
}

class MoreInfo {
  final String title;
  final String image;
  final String description;

  MoreInfo({
    required this.title,
    required this.image,
    required this.description,
  });

  factory MoreInfo.fromJson(Map<String, dynamic> json) {
    return MoreInfo(
      title: json['title'],
      image: json['image'],
      description: json['description'],
    );
  }
}

class ConnectWith {
  final String name;
  final String mobileNo;
  final String email;

  ConnectWith({
    required this.name,
    required this.mobileNo,
    required this.email,
  });

  factory ConnectWith.fromJson(Map<String, dynamic> json) {
    return ConnectWith(
      name: json['name'],
      mobileNo: json['mobileNo'],
      email: json['email'],
    );
  }
}

class FranchiseDetails {
  final String commission;
  final String termsAndConditions;

  FranchiseDetails({
    required this.commission,
    required this.termsAndConditions,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
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
      range: json['range'],
      parameters: json['parameters'],
    );
  }
}

class FranchiseModel {
  final String title;
  final String agreement;
  final int price;
  final int discount;
  final int gst;
  final int fees;

  FranchiseModel({
    required this.title,
    required this.agreement,
    required this.price,
    required this.discount,
    required this.gst,
    required this.fees,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    return FranchiseModel(
      title: json['title'],
      agreement: json['agreement'],
      price: json['price'],
      discount: json['discount'],
      gst: json['gst'],
      fees: json['fees'],
    );
  }
}
