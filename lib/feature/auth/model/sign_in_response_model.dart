import '../../profile/model/user_model.dart';

class SignInResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserModel user;

  SignInResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}


