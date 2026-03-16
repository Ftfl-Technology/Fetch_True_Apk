import 'package:fetchtrue/feature/module/model/module_model.dart';


class CategoryModel {
  final String id;
  final String name;
  final String image;
  final int subcategoryCount;
  final ModuleModel module;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int v;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.subcategoryCount,
    required this.module,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      subcategoryCount: json['subcategoryCount'] ?? 0,
      module: ModuleModel.fromJson(json['module'] ?? {}),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'subcategoryCount': subcategoryCount,
      'module': module.toJson(),
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}


class CategoryResponse {
  final bool success;
  final List<CategoryModel> data;
  // final String newUpdatedAt;

  CategoryResponse({
    required this.success,
    required this.data,
    // required this.newUpdatedAt,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>).map((e) => CategoryModel.fromJson(e)).toList(),
      // newUpdatedAt: json['newUpdatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((e) => e.toJson()).toList(),
      // 'newUpdatedAt': newUpdatedAt,
    };
  }
}

