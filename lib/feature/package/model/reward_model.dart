class RewardModel {
  final String id;
  final String name;
  final String photo;
  final String description;
  final String packageType;
  final String extraMonthlyEarn;
  final String extraMonthlyEarnDescription;

  RewardModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
    required this.packageType,
    required this.extraMonthlyEarn,
    required this.extraMonthlyEarnDescription,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json["_id"],
      name: json["name"] ?? "",
      photo: json["photo"] ?? "",
      description: json["description"] ?? "",
      packageType: json["packageType"] ?? "",
      extraMonthlyEarn: json["extraMonthlyEarn"] ?? "",
      extraMonthlyEarnDescription: json["extraMonthlyEarnDescription"] ?? "",
    );
  }
}
