

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/business_top_trending_service_model.dart';

class BusinessTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<BusinessTopTrendingServiceModel>
  getBusinessTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return BusinessTopTrendingServiceModel.fromJson(response.data);
  }
}
