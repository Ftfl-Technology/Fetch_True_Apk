
class BusinessServiceDetailsModel {
  final String id;
  final String serviceName;
  final Category? category;
  final SubCategory? subcategory;
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
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool isTrending;

  BusinessServiceDetailsModel({
    required this.id,
    required this.serviceName,
    this.category,
    this.subcategory,
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
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
    required this.isTrending,
  });

  factory BusinessServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessServiceDetailsModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
      subcategory: json['subcategory'] != null
          ? SubCategory.fromJson(json['subcategory'])
          : null,
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
      serviceDetails:
      ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
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

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class SubCategory {
  final String id;
  final String name;
  final String image;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }
}

class ServiceDetails {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> highlight;
  final List<AssuredByFetchTrue> assuredByFetchTrue;
  final List<String> termsAndConditions; // ✅ ADD
  final List<Faq> faq;
  final List<WhyChooseUs> whyChooseUs;
  final List<WeItem> weRequired;
  final List<WeItem> weDeliver;
  final List<MoreInfo> moreInfo;
  final List<ConnectWith> connectWith;
  final List<String> brochureImage; // ✅ ADD
  final List<String> emiAvailable; // ✅ ADD
  final List<CompleteSupportSystem> completeSupportSystem; // ✅ ADD
  final List<String> trainingDetails; // ✅ ADD
  final List<String> roi; // ✅ ADD
  final String level; // ✅ ADD
  final int? lessonCount; // ✅ ADD
  final DurationModel duration; // ✅ ADD

  ServiceDetails({
    required this.benefits,
    required this.aboutUs,
    required this.highlight,
    required this.assuredByFetchTrue,
    required this.termsAndConditions,
    required this.faq,
    required this.whyChooseUs,
    required this.weRequired,
    required this.weDeliver,
    required this.moreInfo,
    required this.connectWith,
    required this.brochureImage,
    required this.emiAvailable,
    required this.completeSupportSystem,
    required this.trainingDetails,
    required this.roi,
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
      termsAndConditions:
      List<String>.from(json['termsAndConditions'] ?? []),
      faq: (json['faq'] as List? ?? [])
          .map((e) => Faq.fromJson(e))
          .toList(),
      whyChooseUs: (json['whyChooseUs'] as List? ?? [])
          .map((e) => WhyChooseUs.fromJson(e))
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
      brochureImage:
      List<String>.from(json['brochureImage'] ?? []),
      emiAvailable:
      List<String>.from(json['emiavalable'] ?? []),
      completeSupportSystem:
      (json['completeSupportSystem'] as List? ?? [])
          .map((e) => CompleteSupportSystem.fromJson(e))
          .toList(),
      trainingDetails:
      List<String>.from(json['trainingDetails'] ?? []),
      roi: List<String>.from(json['roi'] ?? []),
      level: json['level'] ?? '',
      lessonCount: json['lessonCount'],
      duration: DurationModel.fromJson(json['duration'] ?? {}),
    );
  }
}

class DurationModel {
  final int weeks;
  final int hours;

  DurationModel({required this.weeks, required this.hours});

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      weeks: json['weeks'] ?? 0,
      hours: json['hours'] ?? 0,
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
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
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
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
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
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
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
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
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
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
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
      name: json['name']?.toString() ?? '',
      mobileNo: json['mobileNo']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }
}

class FranchiseDetails {
  final String commission;
  final String termsAndConditions; // ✅ ADD THIS
  final List<InvestmentRange> investmentRange;
  final List<InvestmentRange> monthlyEarnPotential;
  final List<FranchiseModel> franchiseModel;

  FranchiseDetails({
    required this.commission,
    required this.termsAndConditions,
    required this.investmentRange,
    required this.monthlyEarnPotential,
    required this.franchiseModel,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission']?.toString() ?? '',

      // ✅ NULL SAFE
      termsAndConditions: json['termsAndConditions']?.toString() ?? '',

      investmentRange: (json['investmentRange'] as List? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),

      monthlyEarnPotential: (json['monthlyEarnPotential'] as List? ?? [])
          .map((e) => InvestmentRange.fromJson(e))
          .toList(),

      franchiseModel: (json['franchiseModel'] as List? ?? [])
          .map((e) => FranchiseModel.fromJson(e))
          .toList(),
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
      range: json['range']?.toString() ?? '',
      parameters: json['parameters']?.toString() ?? '',
    );
  }
}

class FranchiseModel {
  final String title;
  final String agreement;
  final int price;
  final int discountedPrice;
  final int discount;
  final int gst;
  final int fees;

  FranchiseModel({
    required this.title,
    required this.agreement,
    required this.price,
    required this.discountedPrice,
    required this.discount,
    required this.gst,
    required this.fees,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    return FranchiseModel(
      title: json['title']?.toString() ?? '',
      agreement: json['agreement']?.toString() ?? '',
      price: json['price'] ?? 0,
      discountedPrice: json['discountedPrice'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      fees: json['fees'] ?? 0,
    );
  }
}
