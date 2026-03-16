import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/cupertino.dart';
import '../model/offer_model.dart';

class OfferRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<OfferModel>> getOffers() async {
    try {
      final response = await _apiClient.get(ApiUrls.offer);
      final result = OfferResponse.fromJson(response.data);
      return result.data;
    }
    on DioException catch (e){
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