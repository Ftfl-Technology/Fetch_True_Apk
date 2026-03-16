

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/finance_popular_service_model.dart';

class FinancePopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FinancePopularServiceModel>
  getFinancePopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return FinancePopularServiceModel.fromJson(response.data);
  }
}
