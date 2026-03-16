import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../model/on_demand_service_details_model.dart';

class OnDemandServiceDetailsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<OnDemandServiceDetailsModel> getServiceById(String id) async {
    try {
      Response response = await _apiClient.get('/service/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return OnDemandServiceDetailsModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load service');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }
}
