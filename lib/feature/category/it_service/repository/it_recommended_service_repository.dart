import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/it_recommended_service_model.dart';

class ItRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ItRecommendedServiceModel>
  getItRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return ItRecommendedServiceModel.fromJson(response.data);
  }
}
