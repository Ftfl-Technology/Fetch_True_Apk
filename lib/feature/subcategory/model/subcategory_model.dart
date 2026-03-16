class SubcategoryModel {
  final String id;
  final String name;
  final String image;
  final bool isDeleted;
  final Category category;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubcategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.isDeleted,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      category: Category.fromJson(json['category'] ?? {}),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'isDeleted': isDeleted,
      'category': category.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Category {
  final String id;
  final String name;
  final String module;
  final String image;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.module,
    required this.image,
    required this.isDeleted,
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
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'module': module,
      'image': image,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}


class SubcategoryResponse {
  final bool success;
  final List<SubcategoryModel> data;
  final String newUpdatedAt;

  SubcategoryResponse({
    required this.success,
    required this.data,
    required this.newUpdatedAt,
  });

  factory SubcategoryResponse.fromJson(Map<String, dynamic> json) {
    return SubcategoryResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>).map((e) => SubcategoryModel.fromJson(e)).toList(),
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