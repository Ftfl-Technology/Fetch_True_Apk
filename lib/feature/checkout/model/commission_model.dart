class CommissionModel {
  final String id;
  final int assurityFee;
  final int platformFee;

  CommissionModel({
    required this.id,
    required this.assurityFee,
    required this.platformFee,
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      id: json['_id'] ?? '',
      assurityFee: json['assurityfee'] ?? 0,
      platformFee: json['platformFee'] ?? 0,
    );
  }
}
