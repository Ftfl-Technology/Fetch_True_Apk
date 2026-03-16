

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/legal_top_trending_service_model.dart';

class LegalTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<LegalTopTrendingServiceModel>
  getLegalTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return LegalTopTrendingServiceModel.fromJson(response.data);
  }
}
