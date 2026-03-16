import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/on_demand_popular_provider_model.dart';

class OnDemandPopularProviderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<OnDemandPopularProviderModel> getOnDemandPopularProviders({
    required String moduleId,
    required double lat,
    required double lng,
  }) async {
    final Response response = await _apiClient.get(
      ApiUrls.popularProviders,
      queryParameters: {
        'moduleId': moduleId,
        'lat': lat,
        'lng': lng,
      },
    );

    return OnDemandPopularProviderModel.fromJson(response.data);
  }
}
