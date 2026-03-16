
import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/category/model/category_model.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';

class CategoryRepository {
  final ApiClient _apiClient = ApiClient();
  Future<List<CategoryModel>> getCategory() async {
    try{
      final response = await _apiClient.get(ApiUrls.modulesCategory);
      final result = CategoryResponse.fromJson(response.data);
      return result.data;
    }
    on DioException catch (e){
      if (e.response != null) {
        print("Category API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        print("Category Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
