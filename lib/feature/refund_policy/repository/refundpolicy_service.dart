import 'dart:convert';
import 'package:fetchtrue/feature/refund_policy/model/refundpolicy_model.dart';
import 'package:http/http.dart' as http;



class RefundPolicyService {
  Future<List<RefundPolicyModel>> fetchContents() async {
    final response = await http.get(
      Uri.parse('https://biz-booster.vercel.app/api/refundpolicy'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> contentList = data['data'];
      return contentList
          .map((json) => RefundPolicyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load content');
    }
  }
}
