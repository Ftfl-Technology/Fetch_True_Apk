import 'package:fetchtrue/feature/category/education/model/education_recommended_service_model.dart';

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';

class EducationRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<EducationRecommendedServiceModel>
  getEducationRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return EducationRecommendedServiceModel.fromJson(response.data);
  }
}
