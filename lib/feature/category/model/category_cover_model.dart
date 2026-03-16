class CategoryCoverModel {
  final bool success;
  final List<CategoryData> data;

  CategoryCoverModel({
    required this.success,
    required this.data,
  });

  factory CategoryCoverModel.fromJson(Map<String, dynamic> json) {
    return CategoryCoverModel(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CategoryData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class CategoryData {
  final String id;
  final Module module;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CategoryData({
    required this.id,
    required this.module,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] ?? '',
      module: Module.fromJson(json['module'] ?? {}),
      image: json['image'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'module': module.toJson(),
    'image': image,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

class Module {
  final String id;
  final String name;
  final String image;

  Module({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'image': image,
  };
}
