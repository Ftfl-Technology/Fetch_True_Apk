import 'package:dio/dio.dart';

import '../../../../helper/api_client.dart';
import '../model/franchise_service_details_model.dart';

class FranchiseServiceDetailsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FranchiseServiceDetailsModel> getServiceById(String id) async {
    try {
      Response response = await _apiClient.get('/service/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FranchiseServiceDetailsModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load service');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }
}
