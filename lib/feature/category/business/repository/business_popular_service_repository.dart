

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/business_popular_service_model.dart';

class BusinessPopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<BusinessPopularServiceModel>
  getBusinessPopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return BusinessPopularServiceModel.fromJson(response.data);
  }
}
