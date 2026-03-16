import 'dart:convert';
import 'package:fetchtrue/feature/about_us/model/aboutus_model.dart';
import 'package:fetchtrue/feature/cancellation_policy/model/cancellationpolicy_model.dart';
import 'package:http/http.dart' as http;



class AboutUsService {
  Future<List<AboutUsModel>> fetchContents() async {
    final response = await http.get(
      Uri.parse('https://biz-booster.vercel.app/api/aboutus'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> contentList = data['data'];
      return contentList
          .map((json) => AboutUsModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load content');
    }
  }
}
