import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';

import '../../../helper/api_client.dart';
import '../model/module_model.dart';


class ModuleRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ModuleModel>> getModules() async {
    try {
      final response = await _apiClient.get(ApiUrls.modules);
      final result = ModuleResponse.fromJson(response.data);
      return result.data;
    } on DioException catch (e){
      if (e.response != null) {
        print("Module API Error [${e.response?.statusCode}]: ${e.response?.data}");
      }
      else {
        print("Module Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
