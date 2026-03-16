
class FranchiseServiceDetailsModel {
  final String id;
  final String serviceName;
  final CategoryModel category;
  final SubCategoryModel subcategory;
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
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final num averageRating;
  final num totalReviews;
  final bool recommendedServices;
  final bool isTrending;
  final bool isDeleted;
  final num sortOrder;
  final String createdAt;
  final String updatedAt;
  final List<KeyValueItem> keyValues;


  FranchiseServiceDetailsModel({
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
    required this.keyValues,

  });

  factory FranchiseServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return FranchiseServiceDetailsModel(
      id: json['_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: CategoryModel.fromJson(json['category'] ?? {}),
      subcategory: SubCategoryModel.fromJson(json['subcategory'] ?? {}),
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
      serviceDetails: _parseServiceDetails(json['serviceDetails']),
      franchiseDetails: _parseFranchiseDetails(json['franchiseDetails']),


      // serviceDetails: ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      // franchiseDetails: FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      keyValues: (json['keyValues'] as List? ?? [])
          .map((e) => KeyValueItem.fromJson(e))
          .toList(),

    );
  }

  static ServiceDetails _parseServiceDetails(dynamic data) {
    if (data is List && data.isNotEmpty) {
      return ServiceDetails.fromJson(data.first);
    }
    if (data is Map<String, dynamic>) {
      return ServiceDetails.fromJson(data);
    }
    return ServiceDetails.fromJson({});
  }

  static FranchiseDetails _parseFranchiseDetails(dynamic data) {
    if (data is List && data.isNotEmpty) {
      return FranchiseDetails.fromJson(data.first);
    }
    if (data is Map<String, dynamic>) {
      return FranchiseDetails.fromJson(data);
    }
    return FranchiseDetails.fromJson({});
  }

}



class CategoryModel {
  final String id;
  final String name;
  final String module;
  final String image;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int sortOrder;

  CategoryModel({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      module: json['module'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final String category;
  final String createdAt;
  final String updatedAt;
  final int sortOrder;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.sortOrder,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      category: json['category'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class ServiceDetails {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> highlight;
  final List<AssuredItem> assuredByFetchTrue;
  final List<String> termsAndConditions;
  final List<FaqItem> faq;
  final List<CommonItem> whyChooseUs;
  final List<CommonItem> weRequired;
  final List<CommonItem> weDeliver;
  final List<MoreInfoItem> moreInfo;
  final List<ContactItem> connectWith;
  final List<String> brochureImage;
  final List<String> emiavalable;
  final List<CounterItem> counter;

  // ✅ NEW ADDED
  final List<FranchiseOperatingModel> franchiseOperatingModel;
  final BusinessFundamental? businessFundamental;
  final List<KeyAdvantage> keyAdvantages;
  final List<CompleteSupportSystem> completeSupportSystem;
  final List<String> trainingDetails;
  final List<String> agreementDetails;
  final List<String> goodThings;
  final List<String> compareAndChoose;
  final List<CompanyDetails> companyDetails;

  final String level;
  final int? lessonCount;
  final DurationModel duration;

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
    required this.emiavalable,
    required this.counter,
    required this.franchiseOperatingModel,
    required this.businessFundamental,
    required this.keyAdvantages,
    required this.completeSupportSystem,
    required this.trainingDetails,
    required this.agreementDetails,
    required this.goodThings,
    required this.compareAndChoose,
    required this.companyDetails,
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
          .map((e) => AssuredItem.fromJson(e))
          .toList(),
      termsAndConditions: List<String>.from(json['termsAndConditions'] ?? []),
      faq: (json['faq'] as List? ?? [])
          .map((e) => FaqItem.fromJson(e))
          .toList(),
      whyChooseUs: (json['whyChooseUs'] as List? ?? [])
          .map((e) => CommonItem.fromJson(e))
          .toList(),
      weRequired: (json['weRequired'] as List? ?? [])
          .map((e) => CommonItem.fromJson(e))
          .toList(),
      weDeliver: (json['weDeliver'] as List? ?? [])
          .map((e) => CommonItem.fromJson(e))
          .toList(),
      moreInfo: (json['moreInfo'] as List? ?? [])
          .map((e) => MoreInfoItem.fromJson(e))
          .toList(),
      connectWith: (json['connectWith'] as List? ?? [])
          .map((e) => ContactItem.fromJson(e))
          .toList(),
      brochureImage: List<String>.from(json['brochureImage'] ?? []),
      emiavalable: List<String>.from(json['emiavalable'] ?? []),
      counter: (json['counter'] as List? ?? [])
          .map((e) => CounterItem.fromJson(e))
          .toList(),

      // ✅ NEW
      franchiseOperatingModel:
      (json['franchiseOperatingModel'] as List? ?? [])
          .map((e) => FranchiseOperatingModel.fromJson(e))
          .toList(),
      businessFundamental: json['businessFundamental'] != null
          ? BusinessFundamental.fromJson(json['businessFundamental'])
          : null,
      keyAdvantages: (json['keyAdvantages'] as List? ?? [])
          .map((e) => KeyAdvantage.fromJson(e))
          .toList(),
      completeSupportSystem:
      (json['completeSupportSystem'] as List? ?? [])
          .map((e) => CompleteSupportSystem.fromJson(e))
          .toList(),
      trainingDetails: List<String>.from(json['trainingDetails'] ?? []),
      agreementDetails: List<String>.from(json['agreementDetails'] ?? []),
      goodThings: List<String>.from(json['goodThings'] ?? []),
      compareAndChoose: List<String>.from(json['compareAndChoose'] ?? []),
      companyDetails: (json['companyDetails'] as List? ?? [])
          .map((e) => CompanyDetails.fromJson(e))
          .toList(),

      level: json['level'] ?? '',
      lessonCount: json['lessonCount'],
      duration: DurationModel.fromJson(json['duration'] ?? {}),
    );
  }
}

class FranchiseOperatingModel {
  final String info;
  final String title;
  final String description;
  final List<OperatingFeature> features;
  final List<String> tags;
  final String example;

  FranchiseOperatingModel({
    required this.info,
    required this.title,
    required this.description,
    required this.features,
    required this.tags,
    required this.example,
  });

  factory FranchiseOperatingModel.fromJson(Map<String, dynamic> json) {
    return FranchiseOperatingModel(
      info: json['info'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      features: (json['features'] as List? ?? [])
          .map((e) => OperatingFeature.fromJson(e))
          .toList(),
      tags: List<String>.from(json['tags'] ?? []),
      example: json['example'] ?? '',
    );
  }
}

class OperatingFeature {
  final String icon;
  final String subtitle;
  final String subDescription;

  OperatingFeature({
    required this.icon,
    required this.subtitle,
    required this.subDescription,
  });

  factory OperatingFeature.fromJson(Map<String, dynamic> json) {
    return OperatingFeature(
      icon: json['icon'] ?? '',
      subtitle: json['subtitle'] ?? '',
      subDescription: json['subDescription'] ?? '',
    );
  }
}

class BusinessFundamental {
  final String description;
  final List<BusinessPoint> points;

  BusinessFundamental({
    required this.description,
    required this.points,
  });

  factory BusinessFundamental.fromJson(Map<String, dynamic> json) {
    return BusinessFundamental(
      description: json['description'] ?? '',
      points: (json['points'] as List? ?? [])
          .map((e) => BusinessPoint.fromJson(e))
          .toList(),
    );
  }
}

class BusinessPoint {
  final String subtitle;
  final String subDescription;

  BusinessPoint({
    required this.subtitle,
    required this.subDescription,
  });

  factory BusinessPoint.fromJson(Map<String, dynamic> json) {
    return BusinessPoint(
      subtitle: json['subtitle'] ?? '',
      subDescription: json['subDescription'] ?? '',
    );
  }
}

class KeyAdvantage {
  final String icon;
  final String title;
  final String description;

  KeyAdvantage({
    required this.icon,
    required this.title,
    required this.description,
  });

  factory KeyAdvantage.fromJson(Map<String, dynamic> json) {
    return KeyAdvantage(
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class KeyValueItem {
  final String key;
  final String value;
  final String icon;

  KeyValueItem({
    required this.key,
    required this.value,
    required this.icon,
  });

  factory KeyValueItem.fromJson(Map<String, dynamic> json) {
    return KeyValueItem(
      key: json['key'] ?? '', // ⚠️ API typo handled
      value: json['value'] ?? '',
      icon: json['icon'] ?? '',
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

class CompanyDetails {
  final String name;
  final String location;
  final String profile;
  final List<CompanyPerson> details;

  CompanyDetails({
    required this.name,
    required this.location,
    required this.profile,
    required this.details,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      profile: json['profile'] ?? '',
      details: (json['details'] as List? ?? [])
          .map((e) => CompanyPerson.fromJson(e))
          .toList(),
    );
  }
}

class CompanyPerson {
  final String title;
  final String description;

  CompanyPerson({
    required this.title,
    required this.description,
  });

  factory CompanyPerson.fromJson(Map<String, dynamic> json) {
    return CompanyPerson(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
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


class AssuredItem {
  final String title;
  final String icon;
  final String description;

  AssuredItem({required this.title, required this.icon, required this.description});

  factory AssuredItem.fromJson(Map<String, dynamic> json) {
    return AssuredItem(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class CommonItem {
  final String title;
  final String description;
  final String? icon;

  CommonItem({required this.title, required this.description, this.icon});

  factory CommonItem.fromJson(Map<String, dynamic> json) {
    return CommonItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'],
    );
  }
}

class MoreInfoItem {
  final String title;
  final String image;
  final String description;

  MoreInfoItem({required this.title, required this.image, required this.description});

  factory MoreInfoItem.fromJson(Map<String, dynamic> json) {
    return MoreInfoItem(
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class ContactItem {
  final String name;
  final String mobileNo;
  final String email;

  ContactItem({required this.name, required this.mobileNo, required this.email});

  factory ContactItem.fromJson(Map<String, dynamic> json) {
    return ContactItem(
      name: json['name'] ?? '',
      mobileNo: json['mobileNo'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class CounterItem {
  final int number;
  final String title;

  CounterItem({
    required this.number,
    required this.title,
  });

  factory CounterItem.fromJson(Map<String, dynamic> json) {
    return CounterItem(
      number: json['number'] ?? 0,
      title: json['title'] ?? '',
    );
  }
}

class FranchiseDetails {
  final String commission;
  final String termsAndConditions;
  final List<RangeModel> investmentRange;
  final List<RangeModel> monthlyEarnPotential;
  final List<FranchiseModelItem> franchiseModel;
  final String areaRequired;


  FranchiseDetails({
    required this.commission,
    required this.termsAndConditions,
    required this.investmentRange,
    required this.monthlyEarnPotential,
    required this.franchiseModel,
    required this.areaRequired,

  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      commission: json['commission'] ?? '',
      termsAndConditions: json['termsAndConditions'] ?? '',
      investmentRange: (json['investmentRange'] as List? ?? [])
          .map((e) => RangeModel.fromJson(e))
          .toList(),
      monthlyEarnPotential: (json['monthlyEarnPotential'] as List? ?? [])
          .map((e) => RangeModel.fromJson(e))
          .toList(),
      franchiseModel: (json['franchiseModel'] as List? ?? [])
          .map((e) => FranchiseModelItem.fromJson(e))
          .toList(),
      areaRequired: json['areaRequired'] ?? '',

    );
  }
}

class RangeModel {
  final String range;
  final String parameters;

  RangeModel({required this.range, required this.parameters});

  factory RangeModel.fromJson(Map<String, dynamic> json) {
    return RangeModel(
      range: json['range'] ?? '',
      parameters: json['parameters'] ?? '',
    );
  }
}

class FranchiseModelItem {
  final String title;
  final String agreement;
  final num price;
  final num discount;
  final num gst;
  final num fees;

  FranchiseModelItem({
    required this.title,
    required this.agreement,
    required this.price,
    required this.discount,
    required this.gst,
    required this.fees,
  });

  factory FranchiseModelItem.fromJson(Map<String, dynamic> json) {
    return FranchiseModelItem(
      title: json['title'] ?? '',
      agreement: json['agreement'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      gst: json['gst'] ?? 0,
      fees: json['fees'] ?? 0,
    );
  }
}
