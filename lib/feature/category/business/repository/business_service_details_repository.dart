import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../model/business_service_details_model.dart';

class BusinessServiceDetailsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<BusinessServiceDetailsModel> getServiceById(String id) async {
    try {
      Response response = await _apiClient.get('/service/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return BusinessServiceDetailsModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load service');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }
}
