class TrendingFranchiseModel {
  final String id;
  final String moduleId;
  final ServiceId serviceId;
  final bool isTrending;
  final String createdAt;
  final String updatedAt;
  final int v;

  TrendingFranchiseModel({
    required this.id,
    required this.moduleId,
    required this.serviceId,
    required this.isTrending,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TrendingFranchiseModel.fromJson(Map<String, dynamic> json) {
    return TrendingFranchiseModel(
      id: json["_id"] ?? "",
      moduleId: json["moduleId"] ?? "",
      serviceId: ServiceId.fromJson(json["serviceId"] ?? {}),
      isTrending: json["isTrending"] ?? false,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "moduleId": moduleId,
      "serviceId": serviceId.toJson(),
      "isTrending": isTrending,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
    };
  }
}

class ServiceId {
  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final String id;
  final String serviceName;
  final String category;
  final String subcategory;
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
  final List<dynamic> keyValues;
  final double averageRating;
  final int totalReviews;
  final bool recommendedServices;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int v;
  final List<ProviderPrice> providerPrices;

  ServiceId({
    required this.serviceDetails,
    required this.franchiseDetails,
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
    required this.averageRating,
    required this.totalReviews,
    required this.recommendedServices,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.providerPrices,
  });

  factory ServiceId.fromJson(Map<String, dynamic> json) {
    return ServiceId(
      serviceDetails: ServiceDetails.fromJson(json["serviceDetails"] ?? {}),
      franchiseDetails: FranchiseDetails.fromJson(json["franchiseDetails"] ?? {}),
      id: json["_id"] ?? "",
      serviceName: json["serviceName"] ?? "",
      category: json["category"] ?? "",
      subcategory: json["subcategory"] ?? "",
      price: json["price"] ?? 0,
      discount: json["discount"] ?? 0,
      gst: json["gst"] ?? 0,
      includeGst: json["includeGst"] ?? false,
      gstInRupees: json["gstInRupees"] ?? 0,
      totalWithGst: json["totalWithGst"] ?? 0,
      discountedPrice: json["discountedPrice"] ?? 0,
      thumbnailImage: json["thumbnailImage"] ?? "",
      bannerImages: List<String>.from(json["bannerImages"] ?? []),
      tags: List<String>.from(json["tags"] ?? []),
      keyValues: json["keyValues"] ?? [],
      averageRating: (json["averageRating"] ?? 0).toDouble(),
      totalReviews: json["totalReviews"] ?? 0,
      recommendedServices: json["recommendedServices"] ?? false,
      isDeleted: json["isDeleted"] ?? false,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
      providerPrices: (json["providerPrices"] as List<dynamic>? ?? [])
          .map((e) => ProviderPrice.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "serviceDetails": serviceDetails.toJson(),
      "franchiseDetails": franchiseDetails.toJson(),
      "_id": id,
      "serviceName": serviceName,
      "category": category,
      "subcategory": subcategory,
      "price": price,
      "discount": discount,
      "gst": gst,
      "includeGst": includeGst,
      "gstInRupees": gstInRupees,
      "totalWithGst": totalWithGst,
      "discountedPrice": discountedPrice,
      "thumbnailImage": thumbnailImage,
      "bannerImages": bannerImages,
      "tags": tags,
      "keyValues": keyValues,
      "averageRating": averageRating,
      "totalReviews": totalReviews,
      "recommendedServices": recommendedServices,
      "isDeleted": isDeleted,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "providerPrices": providerPrices.map((e) => e.toJson()).toList(),
    };
  }
}

class ServiceDetails {
  final String overview;
  final List<String> highlight;
  final String benefits;
  final String howItWorks;
  final String termsAndConditions;
  final String document;
  final List<String> whyChoose;
  final List<Faq> faq;
  final List<dynamic> extraSections;

  ServiceDetails({
    required this.overview,
    required this.highlight,
    required this.benefits,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.document,
    required this.whyChoose,
    required this.faq,
    required this.extraSections,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      overview: json["overview"] ?? "",
      highlight: List<String>.from(json["highlight"] ?? []),
      benefits: json["benefits"] ?? "",
      howItWorks: json["howItWorks"] ?? "",
      termsAndConditions: json["termsAndConditions"] ?? "",
      document: json["document"] ?? "",
      whyChoose: List<String>.from(json["whyChoose"] ?? []),
      faq: (json["faq"] as List<dynamic>? ?? [])
          .map((e) => Faq.fromJson(e))
          .toList(),
      extraSections: json["extraSections"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "overview": overview,
      "highlight": highlight,
      "benefits": benefits,
      "howItWorks": howItWorks,
      "termsAndConditions": termsAndConditions,
      "document": document,
      "whyChoose": whyChoose,
      "faq": faq.map((e) => e.toJson()).toList(),
      "extraSections": extraSections,
    };
  }
}

class FranchiseDetails {
  final String overview;
  final String commission;
  final String howItWorks;
  final String termsAndConditions;
  final List<dynamic> extraSections;

  FranchiseDetails({
    required this.overview,
    required this.commission,
    required this.howItWorks,
    required this.termsAndConditions,
    required this.extraSections,
  });

  factory FranchiseDetails.fromJson(Map<String, dynamic> json) {
    return FranchiseDetails(
      overview: json["overview"] ?? "",
      commission: json["commission"] ?? "",
      howItWorks: json["howItWorks"] ?? "",
      termsAndConditions: json["termsAndConditions"] ?? "",
      extraSections: json["extraSections"] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "overview": overview,
      "commission": commission,
      "howItWorks": howItWorks,
      "termsAndConditions": termsAndConditions,
      "extraSections": extraSections,
    };
  }
}

class Faq {
  final String question;
  final String answer;
  final String id;

  Faq({
    required this.question,
    required this.answer,
    required this.id,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json["question"] ?? "",
      answer: json["answer"] ?? "",
      id: json["_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer": answer,
      "_id": id,
    };
  }
}

class ProviderPrice {
  final String provider;
  final String providerMRP;
  final String providerDiscount;
  final int providerPrice;
  final String providerCommission;
  final String status;
  final String id;

  ProviderPrice({
    required this.provider,
    required this.providerMRP,
    required this.providerDiscount,
    required this.providerPrice,
    required this.providerCommission,
    required this.status,
    required this.id,
  });

  factory ProviderPrice.fromJson(Map<String, dynamic> json) {
    return ProviderPrice(
      provider: json["provider"] ?? "",
      providerMRP: json["providerMRP"] ?? "",
      providerDiscount: json["providerDiscount"] ?? "",
      providerPrice: json["providerPrice"] ?? 0,
      providerCommission: json["providerCommission"] ?? "",
      status: json["status"] ?? "",
      id: json["_id"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "provider": provider,
      "providerMRP": providerMRP,
      "providerDiscount": providerDiscount,
      "providerPrice": providerPrice,
      "providerCommission": providerCommission,
      "status": status,
      "_id": id,
    };
  }
}
