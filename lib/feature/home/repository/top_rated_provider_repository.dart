
import '../../../helper/api_client.dart';
import '../model/top_rated_provider_model.dart';

class TopRatedProviderRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<TopRatedProviderModel>> getTopRatedProviders() async {
    try {
      final response = await _apiClient.get(
        "provider/top-rated",
      );

      final List data = response.data;

      return data
          .map((json) => TopRatedProviderModel.fromJson(json))
          .toList();

    } catch (e) {
      throw Exception("Failed to load top rated providers: $e");
    }
  }
}
