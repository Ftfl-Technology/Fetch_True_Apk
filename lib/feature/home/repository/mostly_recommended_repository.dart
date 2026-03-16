import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/mostly_recommended_model.dart';

class MostlyRecommendedRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<MostlyRecommended>> fetchMostlyRecommended() async {
    try {
      Response response =
      await _apiClient.get(ApiUrls.mostlyRecommended);

      if (response.statusCode == 200) {
        final result =
        MostlyRecommendedResponse.fromJson(response.data);

        return result.data;
      } else {
        throw Exception("Failed to load mostly recommended services");
      }
    } catch (e) {
      throw Exception("Error fetching mostly recommended: $e");
    }
  }
}
