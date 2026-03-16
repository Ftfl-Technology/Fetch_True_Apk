

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/education_top_trending_service_model.dart';

class EducationTopTrendingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<EducationTopTrendingServiceModel>
  getEducationTopTrendingServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.topTrendingService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return EducationTopTrendingServiceModel.fromJson(response.data);
  }
}
