import '../../../../helper/api_client.dart';
import '../../../../helper/api_urls.dart';
import '../model/legal_popular_service_model.dart';

class LegalPopularServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<LegalPopularServiceModel>
  getLegalPopularServices({
    required String moduleId,
  }) async {
    final response = await _apiClient.get(
      ApiUrls.popularService,
      queryParameters: {
        'moduleId': moduleId,
      },
    );

    return LegalPopularServiceModel.fromJson(response.data);
  }
}
