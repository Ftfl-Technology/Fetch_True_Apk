import 'dart:convert';
import 'package:fetchtrue/helper/api_urls.dart';
import 'package:http/http.dart' as http;
import '../../../helper/api_client.dart';
import '../model/my_team_model.dart';

import 'package:dio/dio.dart';
import '../model/my_team_model.dart';

class MyTeamRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<MyTeamModel>> getMyTeam(String userId) async {
    try {
      final response = await _apiClient.get("${ApiUrls.myTeam}/$userId",);
      final result = TeamResponse.fromJson(response.data);
      return result.team;
    } on DioException catch (e) {
      if (e.response != null) {
        print("Team API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("Team Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}