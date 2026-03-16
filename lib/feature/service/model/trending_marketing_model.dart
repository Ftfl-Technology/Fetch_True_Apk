class TrendingMarketingModel {
  final String id;
  final String moduleId;
  final ServiceId serviceId;
  final bool isTrending;
  final String createdAt;
  final String updatedAt;
  final int v;

  TrendingMarketingModel({
    required this.id,
    required this.moduleId,
    required this.serviceId,
    required this.isTrending,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory TrendingMarketingModel.fromJson(Map<String, dynamic> json) {
    return TrendingMarketingModel(
      id: json["_id"]?.toString() ?? "",
      moduleId: json["moduleId"]?.toString() ?? "",
      serviceId: ServiceId.fromJson(json["serviceId"] ?? {}),
      isTrending: json["isTrending"] ?? false,
      createdAt: json["createdAt"]?.toString() ?? "",
      updatedAt: json["updatedAt"]?.toString() ?? "",
      v: _toInt(json["__v"]),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   SERVICE                                  */
/* -------------------------------------------------------------------------- */

class ServiceId {
  final String id;
  final String serviceName;

  final String category;     // ✅ Map/String both handled
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

  final ServiceDetails serviceDetails;
  final FranchiseDetails franchiseDetails;
  final List<ProviderPrice> providerPrices;

  ServiceId({
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
    required this.serviceDetails,
    required this.franchiseDetails,
    required this.providerPrices,
  });

  factory ServiceId.fromJson(Map<String, dynamic> json) {
    return ServiceId(
      id: json["_id"]?.toString() ?? "",
      serviceName: json["serviceName"]?.toString() ?? "",

      category: json["category"] is Map
          ? json["category"]["name"]?.toString() ?? ""
          : json["category"]?.toString() ?? "",

      subcategory: json["subcategory"] is Map
          ? json["subcategory"]["name"]?.toString() ?? ""
          : json["subcategory"]?.toString() ?? "",

      price: _toInt(json["price"]),
      discount: _toInt(json["discount"]),
      gst: _toInt(json["gst"]),
      includeGst: json["includeGst"] ?? false,
      gstInRupees: _toInt(json["gstInRupees"]),
      totalWithGst: _toInt(json["totalWithGst"]),
      discountedPrice: _toInt(json["discountedPrice"]),

      thumbnailImage: json["thumbnailImage"]?.toString() ?? "",

      bannerImages: (json["bannerImages"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      tags: (json["tags"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      keyValues: json["keyValues"] ?? [],

      averageRating: (json["averageRating"] ?? 0).toDouble(),
      totalReviews: _toInt(json["totalReviews"]),
      recommendedServices: json["recommendedServices"] ?? false,
      isDeleted: json["isDeleted"] ?? false,

      createdAt: json["createdAt"]?.toString() ?? "",
      updatedAt: json["updatedAt"]?.toString() ?? "",
      v: _toInt(json["__v"]),

      serviceDetails: json["serviceDetails"] != null
          ? ServiceDetails.fromJson(json["serviceDetails"])
          : ServiceDetails.empty(),

      franchiseDetails: json["franchiseDetails"] != null
          ? FranchiseDetails.fromJson(json["franchiseDetails"])
          : FranchiseDetails.empty(),

      providerPrices: (json["providerPrices"] as List? ?? [])
          .map((e) => ProviderPrice.fromJson(e))
          .toList(),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              SERVICE DETAILS                                */
/* -------------------------------------------------------------------------- */

class ServiceDetails {
  final String overview;
  final List<String> highlight;
  final List<String> benefits;       // ✅ FIXED
  final List<String> howItWorks;      // ✅ FIXED
  final String termsAndConditions;
  final dynamic document;             // ✅ FIXED
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
      overview: json["overview"]?.toString() ?? "",

      highlight: (json["highlight"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      benefits: _toStringList(json["benefits"]),
      howItWorks: _toStringList(json["howItWorks"]),

      termsAndConditions: json["termsAndConditions"]?.toString() ?? "",
      document: json["document"],

      whyChoose: (json["whyChoose"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      faq: (json["faq"] as List? ?? [])
          .map((e) => Faq.fromJson(e))
          .toList(),

      extraSections: json["extraSections"] ?? [],
    );
  }

  factory ServiceDetails.empty() {
    return ServiceDetails(
      overview: "",
      highlight: [],
      benefits: [],
      howItWorks: [],
      termsAndConditions: "",
      document: null,
      whyChoose: [],
      faq: [],
      extraSections: [],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                            FRANCHISE DETAILS                                */
/* -------------------------------------------------------------------------- */

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
      overview: json["overview"]?.toString() ?? "",
      commission: json["commission"]?.toString() ?? "",
      howItWorks: json["howItWorks"]?.toString() ?? "",
      termsAndConditions: json["termsAndConditions"]?.toString() ?? "",
      extraSections: json["extraSections"] ?? [],
    );
  }

  factory FranchiseDetails.empty() {
    return FranchiseDetails(
      overview: "",
      commission: "",
      howItWorks: "",
      termsAndConditions: "",
      extraSections: [],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                     FAQ                                    */
/* -------------------------------------------------------------------------- */

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
      question: json["question"]?.toString() ?? "",
      answer: json["answer"]?.toString() ?? "",
      id: json["_id"]?.toString() ?? "",
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                              PROVIDER PRICE                                 */
/* -------------------------------------------------------------------------- */

class ProviderPrice {
  final String provider;
  final String providerMRP;
  final String providerDiscount;
  final double providerPrice;
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
      provider: json["provider"]?.toString() ?? "",
      providerMRP: json["providerMRP"]?.toString() ?? "",
      providerDiscount: json["providerDiscount"]?.toString() ?? "",
      providerPrice: (json["providerPrice"] ?? 0).toDouble(),
      providerCommission: json["providerCommission"]?.toString() ?? "",
      status: json["status"]?.toString() ?? "",
      id: json["_id"]?.toString() ?? "",
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                HELPERS                                      */
/* -------------------------------------------------------------------------- */

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

List<String> _toStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [value.toString()];
}
