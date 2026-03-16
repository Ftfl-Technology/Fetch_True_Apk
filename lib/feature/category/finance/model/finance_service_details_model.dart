
class FinanceServiceDetailsModel {
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
  final List<KeyValueItem> keyValues;
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

  FinanceServiceDetailsModel({
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

  factory FinanceServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    return FinanceServiceDetailsModel(
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
      keyValues: (json['keyValues'] ?? [])
          .map<KeyValueItem>((e) => KeyValueItem.fromJson(e))
          .toList(),
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails'] ?? {}),
      franchiseDetails:
      FranchiseDetails.fromJson(json['franchiseDetails'] ?? {}),
      averageRating: json['averageRating'] ?? 0,
      totalReviews: json['totalReviews'] ?? 0,
      recommendedServices: json['recommendedServices'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}


class CategoryModel {
  final String id;
  final String name;
  final String module;
  final String image;
  final bool isDeleted;
  final num sortOrder;

  CategoryModel({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
    required this.isDeleted,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      module: json['module'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String image;
  final String category;
  final bool isDeleted;
  final num sortOrder;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.isDeleted,
    required this.sortOrder,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}

class ServiceDetails {
  final List<String> benefits;
  final List<String> aboutUs;
  final List<String> highlight;
  final List<AssuredItem> assuredByFetchTrue;
  final List<HowItWorksItem> howItWorks;
  final List<String> termsAndConditions;
  final List<FaqItem> faq;
  final List<WhyChooseUsItem> whyChooseUs;
  final List<PackageItem> packages;
  final List<CommonItem> weRequired;
  final List<CommonItem> weDeliver;
  final List<MoreInfoItem> moreInfo;
  final List<ContactItem> connectWith;
  final String level;
  final int? lessonCount;
  final DurationModel duration;
  final List<WhomToSellItem> whomToSell;

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
    required this.whomToSell,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      benefits: List<String>.from(json['benefits'] ?? []),
      aboutUs: List<String>.from(json['aboutUs'] ?? []),
      highlight: List<String>.from(json['highlight'] ?? []),
      assuredByFetchTrue: (json['assuredByFetchTrue'] ?? [])
          .map<AssuredItem>((e) => AssuredItem.fromJson(e))
          .toList(),
      howItWorks: (json['howItWorks'] ?? [])
          .map<HowItWorksItem>((e) => HowItWorksItem.fromJson(e))
          .toList(),
      termsAndConditions:
      List<String>.from(json['termsAndConditions'] ?? []),
      faq: (json['faq'] ?? [])
          .map<FaqItem>((e) => FaqItem.fromJson(e))
          .toList(),
      whyChooseUs: (json['whyChooseUs'] ?? [])
          .map<WhyChooseUsItem>((e) => WhyChooseUsItem.fromJson(e))
          .toList(),
      packages: (json['packages'] ?? [])
          .map<PackageItem>((e) => PackageItem.fromJson(e))
          .toList(),
      weRequired: (json['weRequired'] ?? [])
          .map<CommonItem>((e) => CommonItem.fromJson(e))
          .toList(),
      weDeliver: (json['weDeliver'] ?? [])
          .map<CommonItem>((e) => CommonItem.fromJson(e))
          .toList(),
      moreInfo: (json['moreInfo'] ?? [])
          .map<MoreInfoItem>((e) => MoreInfoItem.fromJson(e))
          .toList(),
      connectWith: (json['connectWith'] ?? [])
          .map<ContactItem>((e) => ContactItem.fromJson(e))
          .toList(),
      level: json['level'] ?? '',
      lessonCount: json['lessonCount'],
      duration: DurationModel.fromJson(json['duration'] ?? {}),
      whomToSell: (json['whomToSell'] ?? [])
          .map<WhomToSellItem>((e) => WhomToSellItem.fromJson(e))
          .toList(),
    );
  }
}

class KeyValueItem {
  final String key;
  final String icon;
  final String value;

  KeyValueItem({required this.key, required this.value, required this.icon});

  factory KeyValueItem.fromJson(Map<String, dynamic> json) =>
      KeyValueItem(
        key: json['key'] ?? '',
        icon: json['icon'] ?? '',
        value: json['value'] ?? '',
      );
}

class WhomToSellItem {
  final String icon;
  final String lists;

  WhomToSellItem({required this.icon, required this.lists});

  factory WhomToSellItem.fromJson(Map<String, dynamic> json) =>
      WhomToSellItem(
        icon: json['icon'] ?? '',
        lists: json['lists'] ?? '',
      );
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

  AssuredItem({
    required this.title,
    required this.icon,
    required this.description,
  });

  factory AssuredItem.fromJson(Map<String, dynamic> json) => AssuredItem(
    title: json['title'] ?? '',
    icon: json['icon'] ?? '',
    description: json['description'] ?? '',
  );
}

class HowItWorksItem {
  final String title;
  final String icon;
  final String description;

  HowItWorksItem({
    required this.title,
    required this.icon,
    required this.description,
  });

  factory HowItWorksItem.fromJson(Map<String, dynamic> json) =>
      HowItWorksItem(
        title: json['title'] ?? '',
        icon: json['icon'] ?? '',
        description: json['description'] ?? '',
      );
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) => FaqItem(
    question: json['question'] ?? '',
    answer: json['answer'] ?? '',
  );
}

class WhyChooseUsItem {
  final String title;
  final String icon;
  final String description;

  WhyChooseUsItem({
    required this.title,
    required this.icon,
    required this.description,
  });

  factory WhyChooseUsItem.fromJson(Map<String, dynamic> json) =>
      WhyChooseUsItem(
        title: json['title'] ?? '',
        icon: json['icon'] ?? '',
        description: json['description'] ?? '',
      );
}

class PackageItem {
  final String name;
  final num price;
  final num discount;
  final num discountedPrice;
  final List<String> whatYouGet;

  PackageItem({
    required this.name,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.whatYouGet,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) => PackageItem(
    name: json['name'] ?? '',
    price: json['price'] ?? 0,
    discount: json['discount'] ?? 0,
    discountedPrice: json['discountedPrice'] ?? 0,
    whatYouGet: List<String>.from(json['whatYouGet'] ?? []),
  );
}

class CommonItem {
  final String title;
  final String description;

  CommonItem({required this.title, required this.description});

  factory CommonItem.fromJson(Map<String, dynamic> json) => CommonItem(
    title: json['title'] ?? '',
    description: json['description'] ?? '',
  );
}

class MoreInfoItem {
  final String title;
  final String image;
  final String description;

  MoreInfoItem({
    required this.title,
    required this.image,
    required this.description,
  });

  factory MoreInfoItem.fromJson(Map<String, dynamic> json) =>
      MoreInfoItem(
        title: json['title'] ?? '',
        image: json['image'] ?? '',
        description: json['description'] ?? '',
      );
}

class ContactItem {
  final String name;
  final String mobileNo;
  final String email;

  ContactItem({
    required this.name,
    required this.mobileNo,
    required this.email,
  });

  factory ContactItem.fromJson(Map<String, dynamic> json) => ContactItem(
    name: json['name'] ?? '',
    mobileNo: json['mobileNo'] ?? '',
    email: json['email'] ?? '',
  );
}

class TimeRequiredItem {
  final String range;
  final String parameters;

  TimeRequiredItem({
    required this.range,
    required this.parameters,
  });

  factory TimeRequiredItem.fromJson(Map<String, dynamic> json) =>
      TimeRequiredItem(
        range: json['range'] ?? '',
        parameters: json['parameters'] ?? '',
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

