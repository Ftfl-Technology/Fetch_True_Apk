import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/training_tutorial_model.dart';

class TrainingTutorialService {
  final String baseUrl = 'https://biz-booster.vercel.app/api/academy/certifications';

  Future<List<TrainingTutorialModel>> fetchTrainingTutorial() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return (jsonData['data'] as List)
              .map((e) => TrainingTutorialModel.fromJson(e))
              .toList();
        } else {
          throw Exception("Invalid response structure");
        }
      } else {
        throw Exception("Failed to load certifications: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching certifications: $e");
    }
  }
}
