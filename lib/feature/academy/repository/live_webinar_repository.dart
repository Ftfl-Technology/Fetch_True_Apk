// 📁 lib/feature/live_webinars/data/repositories/live_webinar_repository.dart

import 'package:dio/dio.dart';
import '../model/live_webinar_model.dart';

class LiveWebinarRepository {
  final Dio _dio = Dio();

  final String baseUrl = 'https://biz-booster.vercel.app/api/academy/livewebinars';

  Future<LiveWebinarModel> fetchLiveWebinars() async {
    try {
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        // ✅ Dio automatically decodes JSON
        return LiveWebinarModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load live webinars: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
