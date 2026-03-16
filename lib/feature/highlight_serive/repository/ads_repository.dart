import 'package:dio/dio.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/add_model.dart';


class AdsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<AdsModel>> getAds() async {
    try {
      final response = await _apiClient.get(ApiUrls.ads);
      final result = AdsResponse.fromJson(response.data);
      return result.data;
    }
    on DioException catch (e){
      if (e.response != null) {
        print("${CustomLogEmoji.error} Ads API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        print("${CustomLogEmoji.network} Ads Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}