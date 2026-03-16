

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/franchise_recommended_service_model.dart';

class FranchiseRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FranchiseRecommendedServiceModel>
  getFranchiseRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return FranchiseRecommendedServiceModel.fromJson(response.data);
  }
}
