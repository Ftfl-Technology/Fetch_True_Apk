import 'package:dio/dio.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';

class UserAdditionalDetailsService {
  final ApiClient _apiClient = ApiClient();

  Future<void> updateAdditionalDetails({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _apiClient.patch('${ApiUrls.user}/additional-details/$userId',
        data: data,
      );

    } on DioException catch (e){
      if (e.response != null) {
        final serverMessage = e.response?.data?["message"] ?? "Something went wrong";

        debugPrint("${CustomLogEmoji.error} Additional Details API Error [${e.response?.statusCode}]: $serverMessage");

        throw Exception(serverMessage);

      }
      else {
        debugPrint("${CustomLogEmoji.network} Additional Details Network Error: ${e.message}");

      }
      rethrow;
    }
    }
}
