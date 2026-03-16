import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/subcategory_model.dart';

class SubcategoryRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<SubcategoryModel>> getSubcategories() async {
    try {
      final response = await _apiClient.get(ApiUrls.modulesSubcategory);
      final result = SubcategoryResponse.fromJson(response.data);
      return result.data;
    }
    on DioException catch (e){
      if (e.response != null) {
        print("Subcategory API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        print("Subcategory Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}