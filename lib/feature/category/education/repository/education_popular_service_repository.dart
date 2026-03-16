

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/education_popular_service_model.dart';

class EducationPopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<EducationPopularServiceModel>
  getEducationPopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return EducationPopularServiceModel.fromJson(response.data);
  }
}
