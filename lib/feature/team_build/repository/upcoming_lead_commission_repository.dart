import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/upcoming_lead_commission_model.dart';

class UpcomingLeadCommissionRepository {
  final ApiClient _apiClient = ApiClient();

  Future<UpcomingLeadCommissionModel> fetchCommission(String checkoutId) async {
    try {
      final response = await _apiClient.get(
        "${ApiUrls.upcomingLeadCommission}/$checkoutId",
      );
      if (response.data == null) {
        debugPrint("${CustomLogEmoji.error} Empty response from server");
      }

      return UpcomingLeadCommissionModel.fromJson(response.data);
    }   on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} Offer API Error [${e.response?.statusCode}]: ${e.response?.data}");
        // throw Exception('Failed to load data');
      }
      else {
        debugPrint("${CustomLogEmoji.network}Offer Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
