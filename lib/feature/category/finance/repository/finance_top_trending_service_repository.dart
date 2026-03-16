

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/finance_top_trending_service_model.dart';

class FinanceTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FinanceTopTrendingServiceModel>
  getFinanceTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return FinanceTopTrendingServiceModel.fromJson(response.data);
  }
}
