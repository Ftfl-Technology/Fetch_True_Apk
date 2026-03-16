import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/category_cover_model.dart';

class CategoryCoverRepository {
  final ApiClient _apiClient = ApiClient();

  Future<CategoryCoverModel> getCategoryBanner({required String moduleId}) async {
    try {
      final response = await _apiClient.get(
        ApiUrls.categoryCover,
        queryParameters: {'moduleId': moduleId},
      );
      return CategoryCoverModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        print("CategoryCover API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("CategoryCover Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}