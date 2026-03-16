class ModuleWiseBannerModel {
  final String id;
  final String page;
  final String selectionType;
  final String file;
  final String? screenCategory;
  final ModuleModel? module;
  final SubCategoryModel? subCategory;
  final String? referralUrl;
  final String? service;

  ModuleWiseBannerModel({
    required this.id,
    required this.page,
    required this.selectionType,
    required this.file,
    this.screenCategory,
    this.module,
    this.subCategory,
    this.referralUrl,
    this.service,
  });

  factory ModuleWiseBannerModel.fromJson(Map<String, dynamic> json) {
    return ModuleWiseBannerModel(
      id: json['_id'] ?? '',
      page: json['page'] ?? '',
      selectionType: json['selectionType'] ?? '',
      file: json['file'] ?? '',
      screenCategory: json['screenCategory'],
      module: json['module'] != null ? ModuleModel.fromJson(json['module']) : null,
      subCategory: json['subcategory'] != null
          ? SubCategoryModel.fromJson(json['subcategory'])
          : null,
      referralUrl: json['referralUrl'],
      service: json['service'],
    );
  }
}

class ModuleModel {
  final String id;
  final String name;
  final String image;

  ModuleModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String image;
  final CategoryModel? category;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.category,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] != null ? CategoryModel.fromJson(json['category']) : null,
    );
  }
}

class CategoryModel {
  final String id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
