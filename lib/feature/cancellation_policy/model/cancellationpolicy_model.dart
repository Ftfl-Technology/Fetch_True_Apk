class CancellationPolicyModel {
  final String id;
  final String content;

  CancellationPolicyModel({
    required this.id,
    required this.content,
  });

  factory CancellationPolicyModel.fromJson(Map<String, dynamic> json) {
    return CancellationPolicyModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
