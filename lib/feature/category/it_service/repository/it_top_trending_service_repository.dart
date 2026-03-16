

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/it_top_trending_service_model.dart';

class ItTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ItTopTrendingServiceModel>
  getItTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return ItTopTrendingServiceModel.fromJson(response.data);
  }
}
