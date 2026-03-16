import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/ai_hub_recommended_service_model.dart';

class AiHubRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<AiHubRecommendedServiceModel>
  getAiHubRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return AiHubRecommendedServiceModel.fromJson(response.data);
  }
}
