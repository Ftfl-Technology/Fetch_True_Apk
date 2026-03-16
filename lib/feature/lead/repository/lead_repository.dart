import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../model/lead_model.dart';

class LeadRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<LeadModel>> getLead(String userId) async {
    try {
      final response = await _apiClient.get("${ApiUrls.leads}/$userId");
      final result = LeadResponse.fromJson(response.data);
      return result.data;
    }
    on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} Lead API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        debugPrint("${CustomLogEmoji.network} Lead Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}