

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/marketing_popular_service_model.dart';

class MarketingPopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<MarketingPopularServiceModel>
  getMarketingPopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return MarketingPopularServiceModel.fromJson(response.data);
  }
}
