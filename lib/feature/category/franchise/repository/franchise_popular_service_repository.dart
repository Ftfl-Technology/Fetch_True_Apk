

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/franchise_popular_service_model.dart';
import '../model/franchise_recommended_service_model.dart';

class FranchisePopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FranchisePopularServiceModel>
  getFranchisePopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return FranchisePopularServiceModel.fromJson(response.data);
  }
}
