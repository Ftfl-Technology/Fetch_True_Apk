class ClaimNowDataModel {
  final String id;
  final UserModel user;
  final RewardModel? reward;
  final bool isClaimRequest;
  final bool isExtraMonthlyEarnRequest;
  final bool isAdminApproved;
  final bool isClaimSettled;
  final String createdAt;
  final String rewardTitle;
  final String disclaimer;
  final String rewardPhoto;
  final String rewardDescription;

  ClaimNowDataModel({
    required this.id,
    required this.user,
    this.reward,
    required this.isClaimRequest,
    required this.isExtraMonthlyEarnRequest,
    required this.isAdminApproved,
    required this.isClaimSettled,
    required this.createdAt,
    required this.rewardTitle,
    required this.disclaimer,
    required this.rewardPhoto,
    required this.rewardDescription,
  });

  factory ClaimNowDataModel.fromJson(Map<String, dynamic> json) {
    return ClaimNowDataModel(
      id: json["_id"]?.toString() ?? "",
      user: UserModel.fromJson(json["user"] ?? {}),

      reward: (json["reward"] != null && json["reward"] is Map)
          ? RewardModel.fromJson(json["reward"])
          : null,

      isClaimRequest: json["isClaimRequest"] == true,
      isExtraMonthlyEarnRequest: json["isExtraMonthlyEarnRequest"] == true,
      isAdminApproved: json["isAdminApproved"] == true,
      isClaimSettled: json["isClaimSettled"] == true,

      createdAt: json["createdAt"]?.toString() ?? "",
      rewardTitle: json["rewardTitle"]?.toString() ?? "",
      disclaimer: json["disclaimer"]?.toString() ?? "",
      rewardPhoto: json["rewardPhoto"]?.toString() ?? "",
      rewardDescription: json["rewardDescription"]?.toString() ?? "",
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"]?.toString() ?? "",
      fullName: json["fullName"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
    );
  }
}

class RewardModel {
  final String id;
  final String name;
  final String photo;
  final String description;

  RewardModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.description,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json["_id"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      photo: json["photo"]?.toString() ?? "",
      description: json["description"]?.toString() ?? "",
    );
  }
}
