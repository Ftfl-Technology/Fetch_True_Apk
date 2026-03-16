
class SignUpModel {
  final String fullName;
  final String email;
  final String mobileNumber;
  final String password;
  final String? referredBy;
  final bool isAgree;

  SignUpModel({
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    this.referredBy,
    required this.isAgree,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "mobileNumber": mobileNumber,
      "password": password,
      "referredBy": referredBy ?? "",
      "isAgree": isAgree,
    };
  }

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      password: json['password'] ?? '',
      referredBy: json['referredBy'] ?? '',
      isAgree: json['isAgree'] ?? false,
    );
  }
}
