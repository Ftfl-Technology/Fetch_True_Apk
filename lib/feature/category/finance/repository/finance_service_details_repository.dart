import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../model/finance_service_details_model.dart';

class FinanceServiceDetailsRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FinanceServiceDetailsModel> getServiceById(String id) async {
    try {
      Response response = await _apiClient.get('/service/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FinanceServiceDetailsModel.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to load service');
      }
    } catch (e) {
      throw Exception('Error fetching service: $e');
    }
  }
}
