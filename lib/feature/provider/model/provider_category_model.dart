class ProviderCategoryModel {
  final String id;
  final String name;

  ProviderCategoryModel({
    required this.id,
    required this.name,
  });

  factory ProviderCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProviderCategoryModel(
      id: json['_id'],
      name: json['name'],
    );
  }
}
