import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/package_model.dart';

class PackageRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<PackageModel>> getPackages() async {
    try {
      final response = await _apiClient.get(ApiUrls.packages);

      if (response.data is List) {
        return (response.data as List)
            .map((item) => PackageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      else if (response.data is Map) {
        return [PackageModel.fromJson(response.data as Map<String, dynamic>)];
      }
      else {
        return [];
      }
    }
    on DioException catch (e) {
      if (e.response != null) {
        print("Package API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("Package Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}
