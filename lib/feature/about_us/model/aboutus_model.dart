class AboutUsModel {
  final String id;
  final String content;

  AboutUsModel({
    required this.id,
    required this.content,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
