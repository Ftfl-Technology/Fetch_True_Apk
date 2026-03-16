import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../service/model/service_model.dart';

Future<List<ServiceModel>> fetchServices() async {
  final url = Uri.parse('https://biz-booster.vercel.app/api/service');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List servicesJson = data['data'] ?? [];
    return servicesJson.map((json) => ServiceModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load services');
  }
}
