import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/finance_recommended_service_model.dart';

class FinanceRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FinanceRecommendedServiceModel>
  getFinanceRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return FinanceRecommendedServiceModel.fromJson(response.data);
  }
}
