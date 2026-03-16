import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/partner_review_model.dart';

class PartnerReviewService {
  static const String baseUrl =
      'https://biz-booster.vercel.app/api/partnerreview';

  /// API से Partner Reviews data fetch करें
  static Future<PartnerReviewResponse> getPartnerReviews() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return PartnerReviewResponse.fromJson(jsonData);
      } else {
        throw Exception(
            'Failed to load partner reviews. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching partner reviews: $e');
    }
  }
}
