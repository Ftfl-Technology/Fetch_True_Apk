import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/reward_model.dart';

class RewardRepository {
  final String baseUrl =
      "https://api.fetchtrue.com/api/reward-management/reward";

  Future<List<RewardModel>> getRewards() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      List<dynamic> list = jsonData["data"];

      return list.map((e) => RewardModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load rewards");
    }
  }
}
