import 'package:fetchtrue/feature/category/education/model/education_recommended_service_model.dart';

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/legal_recommended_service_model.dart';

class LegalRecommendedServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<LegalRecommendedServiceModel>
  getLegalRecommendedServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.recommendedService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return LegalRecommendedServiceModel.fromJson(response.data);
  }
}
