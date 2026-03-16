class TermsConditionsModel {
  final String id;
  final String content;

  TermsConditionsModel({
    required this.id,
    required this.content,
  });

  factory TermsConditionsModel.fromJson(Map<String, dynamic> json) {
    return TermsConditionsModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
