import '../../profile/model/user_model.dart';

class SignUpResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserModel user;

  SignUpResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}


