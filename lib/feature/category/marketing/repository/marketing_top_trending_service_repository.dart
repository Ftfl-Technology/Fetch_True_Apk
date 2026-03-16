

import 'package:fetchtrue/feature/category/marketing/model/marketing_top_trending_service_model.dart';
import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';

class MarketingTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<MarketingTopTrendingServiceModel>
  getMarketingTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return MarketingTopTrendingServiceModel.fromJson(response.data);
  }
}
