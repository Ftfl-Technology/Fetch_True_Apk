import 'package:dio/dio.dart';
import '../model/address_model.dart';
import '../../../helper/api_urls.dart';
import '../../../helper/api_client.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';

class AddressRepository {
  final ApiClient _apiClient = ApiClient();

  Future<String> addOrUpdateAddress({
    required String userId,
    required AddressModel addressModel,
  }) async {
    try {
      final response = await _apiClient.patch(
        "${ApiUrls.user}/add-address/$userId",
        data: addressModel.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['message'] ?? 'Address updated successfully';
      } else {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} Address API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        debugPrint("${CustomLogEmoji.network} Address Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
