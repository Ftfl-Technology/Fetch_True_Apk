import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/FiveXModel.dart';

class FiveXRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<FiveXModel>> fetchFiveXData() async {
    try {
      final response = await _apiClient.get(ApiUrls.fiveX);
      final List<dynamic> data = response.data;
      return data.map((json) => FiveXModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} FiveX API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        debugPrint("${CustomLogEmoji.network} FiveX Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
