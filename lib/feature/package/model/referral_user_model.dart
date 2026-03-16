class ReferralUser {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final DateTime createdAt;

  ReferralUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.createdAt,
  });

  factory ReferralUser.fromJson(Map<String, dynamic> json) {
    return ReferralUser(
      id: json["_id"],
      fullName: json["fullName"],
      email: json["email"],
      mobileNumber: json["mobileNumber"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}
