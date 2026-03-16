import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/recorded_webinar_model.dart';

class RecordedWebinarService {
  final String baseUrl = 'https://biz-booster.vercel.app/api/academy/webinars';

  Future<RecordedWebinarModel?> fetchRecordedWebinars() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return RecordedWebinarModel.fromJson(jsonData);
      } else {
        print('Failed to load webinars. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception caught while fetching webinars: $e');
      return null;
    }
  }
}
