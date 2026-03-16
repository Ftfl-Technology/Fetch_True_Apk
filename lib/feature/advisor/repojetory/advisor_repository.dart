import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';

import '../model/advisor_model.dart';

class AdvisorRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<AdvisorModel>> fetchAdvisors() async {
    try {
      final Response response = await _apiClient.get(ApiUrls.advisor);

      if (response.statusCode == 200 || response.statusCode == 201) {

        final advisorResponse = AdvisorResponse.fromJson(response.data);

        return advisorResponse.data;
      }

      throw Exception("Failed with status: ${response.statusCode}");
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.message}");
    } catch (e) {
      throw Exception("Advisor API error: $e");
    }
  }
}