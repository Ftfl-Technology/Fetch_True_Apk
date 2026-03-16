class OfferModel {
  final String id;
  final String thumbnailImage;
  final String bannerImage;
  final DateTime offerStartTime;
  final DateTime offerEndTime;
  final List<String> galleryImages;
  final String eligibilityCriteria;
  final String howToParticipate;
  final List<Faq> faq;
  final String termsAndConditions;
  final String serviceName;

  OfferModel({
    required this.id,
    required this.thumbnailImage,
    required this.bannerImage,
    required this.offerStartTime,
    required this.offerEndTime,
    required this.galleryImages,
    required this.eligibilityCriteria,
    required this.howToParticipate,
    required this.faq,
    required this.termsAndConditions,
    required this.serviceName,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json["_id"],
      thumbnailImage: json["thumbnailImage"] ?? '',
      bannerImage: json["bannerImage"] ?? '',
      offerStartTime: DateTime.tryParse(json["offerStartTime"] ?? '') ?? DateTime.now(),
      offerEndTime: DateTime.tryParse(json["offerEndTime"] ?? '') ?? DateTime.now(),
      galleryImages: List<String>.from(json["galleryImages"] ?? []),
      eligibilityCriteria: json["eligibilityCriteria"] ?? '',
      howToParticipate: json["howToParticipate"] ?? '',
      faq: (json["faq"] as List<dynamic>?)
          ?.map((e) => Faq.fromJson(e))
          .toList() ??
          [],
      termsAndConditions: json["termsAndConditions"] ?? '',
      serviceName: json["service"]?["serviceName"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "thumbnailImage": thumbnailImage,
      "bannerImage": bannerImage,
      "offerStartTime": offerStartTime.toIso8601String(),
      "offerEndTime": offerEndTime.toIso8601String(),
      "galleryImages": galleryImages,
      "eligibilityCriteria": eligibilityCriteria,
      "howToParticipate": howToParticipate,
      "faq": faq.map((e) => e.toJson()).toList(),
      "termsAndConditions": termsAndConditions,
      "serviceName": serviceName,
    };
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json["question"] ?? '',
      answer: json["answer"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question": question,
      "answer": answer,
    };
  }
}


class OfferResponse {
  final bool success;
  final List<OfferModel> data;
  final String newUpdatedAt;

  OfferResponse({
    required this.success,
    required this.data,
    required this.newUpdatedAt,
  });

  factory OfferResponse.fromJson(Map<String, dynamic> json) {
    return OfferResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>).map((e) => OfferModel.fromJson(e)).toList(),
      newUpdatedAt: json['newUpdatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      'newUpdatedAt': newUpdatedAt,
    };
  }
}