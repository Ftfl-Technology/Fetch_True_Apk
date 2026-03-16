import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/terms_conditions_model.dart';

class TermsConditionsService {
  Future<TermsConditionsModel> fetchTerms() async {
    final response = await http.get(
      Uri.parse('https://biz-booster.vercel.app/api/termsconditions'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return TermsConditionsModel.fromJson(data['data'][0]);
    } else {
      throw Exception('Failed to load terms & conditions');
    }
  }
}
