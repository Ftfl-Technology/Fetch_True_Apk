class AdsResponse {
  final bool success;
  final List<AdsModel> data;

  AdsResponse({
    required this.success,
    required this.data,
  });

  factory AdsResponse.fromJson(Map<String, dynamic> json) {
    return AdsResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdsModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AdsModel {
  final String id;
  final String addType;
  final Category category;
  final Service service;
  final String startDate;
  final String endDate;
  final String title;
  final String description;
  final String fileUrl;
  final bool isExpired;
  final bool isApproved;

  AdsModel({
    required this.id,
    required this.addType,
    required this.category,
    required this.service,
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.isExpired,
    required this.isApproved,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) {
    return AdsModel(
      id: json['_id'] ?? '',
      addType: json['addType'] ?? '',
      category: Category.fromJson(json['category']),
      service: Service.fromJson(json['service']),
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      isExpired: json['isExpired'] ?? false,
      isApproved: json['isApproved'] ?? false,
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

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      module: json['module'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class Service {
  final String id;

  Service({
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? '',
    );
  }
}


