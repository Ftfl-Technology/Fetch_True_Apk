

import '../../module/model/module_model.dart';

/// ModuleCategoryModel.dart
class ModuleCategoryModel {
  final String id;
  final String name;
  final String image;
  final int subcategoryCount;
  final ModuleModel module;

  ModuleCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.subcategoryCount,
    required this.module,
  });

  factory ModuleCategoryModel.fromJson(Map<String, dynamic> json) {
    return ModuleCategoryModel(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
      subcategoryCount: json['subcategoryCount'],
      module: ModuleModel.fromJson(json['module']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'subcategoryCount': subcategoryCount,
      'module': module,
    };
  }
}


