import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/ai_hub_top_trending_service_model.dart';

class AiHubTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<AiHubTopTrendingServiceModel>
  getAiHubTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return AiHubTopTrendingServiceModel.fromJson(response.data);
  }
}
