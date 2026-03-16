import 'package:equatable/equatable.dart';

class WhyJustOurServiceModel extends Equatable {
  final bool success;
  final List<WhyServiceData> data;

  const WhyJustOurServiceModel({
    required this.success,
    required this.data,
  });

  factory WhyJustOurServiceModel.fromJson(Map<String, dynamic> json) {
    return WhyJustOurServiceModel(
      success: json['success'] ?? false,
      data: (json['data'] as List? ?? [])
          .map((e) => WhyServiceData.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [success, data];
}

class WhyServiceData extends Equatable {
  final String id;
  final List<WhyServiceItem> items;
  final Module module;

  const WhyServiceData({
    required this.id,
    required this.items,
    required this.module,
  });

  factory WhyServiceData.fromJson(Map<String, dynamic> json) {
    return WhyServiceData(
      id: json['_id'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((e) => WhyServiceItem.fromJson(e))
          .toList(),
      module: Module.fromJson(json['module'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [id, items, module];
}

class WhyServiceItem extends Equatable {
  final String title;
  final String description;
  final String icon;
  final String? list; // ✅ NEW OPTIONAL FIELD

  const WhyServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    this.list,
  });

  factory WhyServiceItem.fromJson(Map<String, dynamic> json) {
    return WhyServiceItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      list: json['list'], // 🔥 safe (may be null)
    );
  }

  @override
  List<Object?> get props => [title, description, icon, list];
}

class Module extends Equatable {
  final String id;
  final String name;

  const Module({
    required this.id,
    required this.name,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name];
}
