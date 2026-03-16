import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/why_just_our_service_model.dart';

class WhyJustOurServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<WhyJustOurServiceModel> fetchWhyJustOurService({
    required String moduleId,
  }) async {
    try {
      final Response response = await _apiClient.get(
        'category/whyjustourservice',
        queryParameters: {
          'moduleid': moduleId,
        },
      );

      return WhyJustOurServiceModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load Why Just Our Service: $e');
    }
  }
}
