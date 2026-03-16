import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/extra_service_model.dart';

class ExtraServiceRepository {
  Future<ExtraServiceResponse> fetchExtraServices(String checkoutId) async {
    final url = Uri.parse(
      'https://api.fetchtrue.com/api/leads/FindByCheckout/$checkoutId',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData['success'] == true && jsonData['data'] != null) {
        // ✅ Parse the full response (admin + extra services)
        return ExtraServiceResponse.fromJson(jsonData);
      } else {
        // Return empty model (default)
        return ExtraServiceResponse(isAdminApproved: false, services: []);
      }
    } else {
      throw Exception('Failed to load Extra Services');
    }
  }
}
