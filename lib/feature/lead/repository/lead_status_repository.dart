import 'package:dio/dio.dart';

import '../model/lead_status_model.dart';

class LeadStatusRepository {
  final Dio _dio = Dio();

  Future<LeadStatusModel?> fetchLeadStatusByCheckout(String checkoutId) async {
    try {
      final response = await _dio.get(
        'https://biz-booster.vercel.app/api/leads/FindByCheckout/$checkoutId',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return LeadStatusModel.fromJson(response.data['data']);
      } else {
        print("Error: ${response.data}");
        return null;
      }
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
}
