import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../model/user_model.dart';

class UserByIdRepository {
  final ApiClient _apiClient = ApiClient();

  Future<UserModel> getUserById(String userId) async {
    try {
      final response = await _apiClient.get("${ApiUrls.user}/$userId");

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to load user");
      }
    } on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} User API Error [${e.response?.statusCode}]: ${e.response?.data}");
        // throw Exception('Failed to load data');
      }
      else {
        debugPrint("${CustomLogEmoji.network} User Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
