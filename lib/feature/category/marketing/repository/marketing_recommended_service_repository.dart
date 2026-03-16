

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/marketing_recommended_service_model.dart';

class MarketingRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<MarketingRecommendedServiceModel>
  getMarketingRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return MarketingRecommendedServiceModel.fromJson(response.data);
  }
}
