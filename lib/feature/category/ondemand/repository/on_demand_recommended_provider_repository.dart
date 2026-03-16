import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/on_demand_recommended_provider_model.dart';

class OnDemandRecommendedProviderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<OnDemandRecommendedProviderModel> getOnDemandRecommendedProviders({
    required String moduleId,
    required double lat,
    required double lng,
  }) async {
    final Response response = await _apiClient.get(
      ApiUrls.recommendedProviders,
      queryParameters: {
        'moduleId': moduleId,
        'lat': lat,
        'lng': lng,
      },
    );

    return OnDemandRecommendedProviderModel.fromJson(response.data);
  }
}
