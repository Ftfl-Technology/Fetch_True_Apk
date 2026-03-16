import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/business_recommended_service_model.dart';

class BusinessRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<BusinessRecommendedServiceModel>
  getBusinessRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return BusinessRecommendedServiceModel.fromJson(response.data);
  }
}
