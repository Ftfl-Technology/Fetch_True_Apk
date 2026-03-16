

import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/it_popular_service_model.dart';

class ItPopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ItPopularServiceModel>
  getItPopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return ItPopularServiceModel.fromJson(response.data);
  }
}
