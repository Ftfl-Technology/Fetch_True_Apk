import 'package:dio/dio.dart';
import '../../../../helper/api_client.dart';
import '../model/investment_model.dart';

class InvestmentRepository {
  final ApiClient _apiClient = ApiClient();

  /// GET Investment by Service ID
  Future<InvestmentResponse> getInvestmentByServiceId(String serviceId) async {
    try {
      final Response response = await _apiClient.get(
        "service/franchise/investment",
        queryParameters: {
          "serviceId": serviceId,
        },
      );

      if (response.statusCode == 200) {
        return InvestmentResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to load investment data");
      }
    } catch (e) {
      throw Exception("Investment API Error: $e");
    }
  }
}
