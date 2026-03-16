class ModuleModel {
  final int? sortOrder;
  final String? id;
  final String? name;
  final String? image;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final int? categoryCount;

  ModuleModel({
     this.sortOrder,
     this.id,
     this.name,
     this.image,
     this.isDeleted,
     this.createdAt,
     this.updatedAt,
     this.v,
     this.categoryCount,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      sortOrder: json['sortOrder'] ?? 0,
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
      categoryCount: json['categoryCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sortOrder': sortOrder,
      '_id': id,
      'name': name,
      'image': image,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'categoryCount': categoryCount,
    };
  }
}

class ModuleResponse {
  final bool success;
  final List<ModuleModel> data;
  final String newUpdatedAt;

  ModuleResponse({
    required this.success,
    required this.data,
    required this.newUpdatedAt,
  });

  factory ModuleResponse.fromJson(Map<String, dynamic> json) {
    return ModuleResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List<dynamic>).map((e) => ModuleModel.fromJson(e)).toList(),
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
