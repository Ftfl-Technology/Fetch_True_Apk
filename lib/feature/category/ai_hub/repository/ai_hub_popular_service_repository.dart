import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/ai_hub_popular_service_model.dart';

class AiHubPopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<AiHubPopularServiceModel>
  getAiHubPopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return AiHubPopularServiceModel.fromJson(response.data);
  }
}
