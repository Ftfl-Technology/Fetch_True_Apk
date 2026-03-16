import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/auth/model/sign_in_model.dart';
import 'package:fetchtrue/feature/auth/model/sign_in_response_model.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';

class SignInRepository {
  final ApiClient _apiClient = ApiClient();

  Future<SignInResponseModel> signIn(SignInModel signInData) async {
    try {
      final response = await _apiClient.post(
        ApiUrls.signIn,
        data: signInData.toJson(),
      );
      return SignInResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null) {
        errorMessage = e.response?.data['error'] ?? "Unknown error";
        debugPrint("${CustomLogEmoji.error} Sign In API Error "
            "[${e.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = e.message ?? "Network Error";
        debugPrint(
          "${CustomLogEmoji.network} Sign In Network Error: $errorMessage",
        );
      }
      throw errorMessage;
    }
  }
}
