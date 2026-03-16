
import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';

class UserRepository {
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

  Future<UserModel> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.patch(
        "${ApiUrls.userUpdateInfo}/$userId",
        data: data,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to update user");
      }
    }on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} User Info API Error [${e.response?.statusCode}]: ${e.response?.data}");
        // throw Exception('Failed to load data');
      }
      else {
        debugPrint("${CustomLogEmoji.network} User Info Network Error: ${e.message}");
      }
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await _apiClient.delete("${ApiUrls.user}/$userId");

      if (response.statusCode == 200 && response.data["success"] == true) {
        // User deleted successfully
        return;
      } else {
        throw Exception(response.data["message"] ?? "Failed to delete user");
      }
    }on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} User Delete API Error [${e.response?.statusCode}]: ${e.response?.data}");
        // throw Exception('Failed to load data');
      }
      else {
        debugPrint("${CustomLogEmoji.network} User Delete Network Error: ${e.message}");
      }
      rethrow;
    }
  }


  Future<UserModel> updateProfilePhoto(String userId, String filePath) async {
    try {
      final formData = FormData.fromMap({
        "profilePhoto": await MultipartFile.fromFile(filePath),
      });

      final response = await _apiClient.patch(
        "${ApiUrls.userUpdateProfile}/$userId",
        data: formData,
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return UserModel.fromJson(response.data["data"]);
      } else {
        throw Exception(response.data["message"] ?? "Failed to update profile photo");
      }
    }on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} User Image API Error [${e.response?.statusCode}]: ${e.response?.data}");
        // throw Exception('Failed to load data');
      }
      else {
        debugPrint("${CustomLogEmoji.network} User Image Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}