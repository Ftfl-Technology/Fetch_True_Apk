import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/module_wise_recommended_service_model.dart';

class ModuleWiseRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ModuleWiseRecommendedServiceResponse> getModuleWiseRecommendedServices({
    required String moduleId,
  }) async {
    final Response response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      return ModuleWiseRecommendedServiceResponse.fromJson(response.data);
    } else {
      throw Exception('Unable to fetch recommended services');
    }
  }
}
