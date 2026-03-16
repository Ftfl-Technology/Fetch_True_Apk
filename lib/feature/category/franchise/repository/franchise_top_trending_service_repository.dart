

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/franchise_top_trending_service_model.dart';

class FranchiseTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FranchiseTopTrendingServiceModel>
  getFranchiseTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return FranchiseTopTrendingServiceModel.fromJson(response.data);
  }
}
