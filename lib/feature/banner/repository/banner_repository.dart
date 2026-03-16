import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/banners_model.dart';

class BannerRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<BannerModel>> getBanner() async {
    try {
      final response = await _apiClient.get(ApiUrls.banner);
      final List data = response.data as List;
      return data.map((json)=> BannerModel.fromJson(json)).toList();
    }
    on DioException catch (e){
      if (e.response != null) {
        print("Banner API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        print("Banner Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}