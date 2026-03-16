import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/privacypolicy_model.dart';


class PrivacyPolicyService {
  Future<List<PrivacyPolicyModel>> fetchContents() async {
    final response = await http.get(
      Uri.parse('https://biz-booster.vercel.app/api/privacypolicy'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> contentList = data['data'];
      return contentList
          .map((json) => PrivacyPolicyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load content');
    }
  }
}
