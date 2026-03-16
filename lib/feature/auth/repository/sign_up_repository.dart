// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../model/sign_up_model.dart';
import '../model/sign_up_response_model.dart';


class SignUpRepository {
  final ApiClient _apiClient = ApiClient();

  Future<SignUpResponseModel> registerUser(SignUpModel signUpData) async {
    try {
      final response = await _apiClient.post(
        ApiUrls.signUp,
        data: signUpData.toJson(),
      );
      return SignUpResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null) {
        errorMessage = e.response?.data['error'] ?? "Unknown error";
        debugPrint("${CustomLogEmoji.error} Register API Error "
              "[${e.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = e.message ?? "Network Error";
        debugPrint(
          "${CustomLogEmoji.network} Register Network Error: $errorMessage",
        );
      }
      throw errorMessage;
    }
  }
}
