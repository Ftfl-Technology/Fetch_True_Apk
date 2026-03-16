import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/on_demand_recommended_provider_model.dart';
import '../model/on_demand_top_trending_provider_model.dart';

class OnDemandTopTrendingProviderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<OnDemandTopTrendingProviderModel> getOnDemandTopTrendingProviders({
    required String moduleId,
    required double lat,
    required double lng,
  }) async {
    final Response response = await _apiClient.get(
      ApiUrls.trendingProviders,
      queryParameters: {
        'moduleId': moduleId,
        'lat': lat,
        'lng': lng,
      },
    );

    return OnDemandTopTrendingProviderModel.fromJson(response.data);
  }
}
