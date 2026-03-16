import 'package:dio/dio.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';

import '../../../helper/api_client.dart';
import '../model/provider_model.dart';

class ProviderRepository {
  final ApiClient _apiClient = ApiClient();

  /// All provider
  Future<List<ProviderModel>> getProvider({
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _apiClient.get(
        '${ApiUrls.provider}?lat=$lat&lng=$lng',
      );
      final List data = (response.data as List?) ?? [];
      return data.map((json) => ProviderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} Provider API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        debugPrint("${CustomLogEmoji.network} Provider Network Error: ${e.message}");
      }
      rethrow;
    }
  }
  // Future<List<ProviderModel>> getProvider() async {
  //   try {
  //     final response = await _apiClient.get(ApiUrls.provider);
  //     final List data = (response.data as List?) ?? [];
  //     return data.map((json)=> ProviderModel.fromJson(json)).toList();
  //   }
  //   on DioException catch (e){
  //     if (e.response != null) {
  //       debugPrint("${CustomLogEmoji.error} Provider API Error [${e.response?.statusCode}]: ${e.response?.data}");
  //     }
  //     else {
  //       debugPrint("${CustomLogEmoji.network}Provider Network Error: ${e.message}");
  //     }
  //     rethrow;
  //   }
  // }

  /// Provider by id
  Future<ProviderModel?> getProviderById(String providerId) async {
    try {
      final response = await _apiClient.get('${ApiUrls.provider}/$providerId');
      if(response.data != null){
        return ProviderModel.fromJson(response.data);
      }
      return null;
    }
    on DioException catch (e){
      if (e.response != null) {
        debugPrint("${CustomLogEmoji.error} Provider API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        debugPrint("${CustomLogEmoji.network}Provider Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}