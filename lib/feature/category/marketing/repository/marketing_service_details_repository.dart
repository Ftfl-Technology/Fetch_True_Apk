import 'package:dio/dio.dart';

import '../../../../helper/api_client.dart';
import '../model/marketing_service_details_model.dart';

class MarketingServiceRepository {
  final ApiClient _apiClient = ApiClient();

  Future<MarketingServiceDetailsModel> getServiceById(String id) async {
    try {
      Response response = await _apiClient.get('/service/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return MarketingServiceDetailsModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load service');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }
}
