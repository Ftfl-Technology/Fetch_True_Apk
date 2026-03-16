class RefundPolicyModel {
  final String id;
  final String content;

  RefundPolicyModel({
    required this.id,
    required this.content,
  });

  factory RefundPolicyModel.fromJson(Map<String, dynamic> json) {
    return RefundPolicyModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
