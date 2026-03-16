import 'dart:convert';
import 'package:fetchtrue/feature/cancellation_policy/model/cancellationpolicy_model.dart';
import 'package:http/http.dart' as http;



class CancellationPolicyService {
  Future<List<CancellationPolicyModel>> fetchContents() async {
    final response = await http.get(
      Uri.parse('https://biz-booster.vercel.app/api/cancellationpolicy'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> contentList = data['data'];
      return contentList
          .map((json) => CancellationPolicyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load content');
    }
  }
}
