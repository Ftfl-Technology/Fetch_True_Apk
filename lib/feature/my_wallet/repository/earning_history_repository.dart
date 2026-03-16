import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/earning_history_model.dart';

class EarningHistoryRepository {
  Future<List<EarningHistory>> fetchEarningHistory(String userId, int page, int limit) async {
    final url = Uri.parse(
        'https://api.fetchtrue.com/api/users/my-earning-history/$userId?page=$page&limit=$limit');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        final List list = data['data'];
        return list.map((item) => EarningHistory.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch earning history');
      }
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
