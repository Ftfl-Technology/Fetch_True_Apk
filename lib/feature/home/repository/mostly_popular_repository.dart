import 'package:dio/dio.dart';
import 'package:fetchtrue/feature/home/model/mostly_popular_model.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/mostly_recommended_model.dart';

class MostlyPopularRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<MostlyPopular>> fetchMostlyPopular() async {
    try {
      Response response =
      await _apiClient.get(ApiUrls.mostlyPopular);

      if (response.statusCode == 200) {
        final result =
        MostlyPopularResponse.fromJson(response.data);

        return result.data;
      } else {
        throw Exception("Failed to load mostly recommended services");
      }
    } catch (e) {
      throw Exception("Error fetching mostly recommended: $e");
    }
  }
}
