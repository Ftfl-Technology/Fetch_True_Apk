import 'package:dio/dio.dart';
import '../model/trending_marketing_model.dart';

class TrendingMarketingRepository {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://api.fetchtrue.com/api"),
  );

  Future<List<TrendingMarketingModel>> fetchTrendingMarketing() async {
    try {
      final response = await _dio.get("/trending-modules/marketing");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        return data.map((json) {
          return TrendingMarketingModel.fromJson(json);
        }).toList();
      } else {
        print("⚠️ API Failed with status: ${response.statusCode}");
        throw Exception("Failed to load data");
      }
    } on DioError catch (dioError) {
      print("❌ DioError: ${dioError.message}");
      if (dioError.response != null) {
        print("📌 DioError Response Data: ${dioError.response?.data}");
      }
      throw Exception("DioError occurred: ${dioError.message}");
    } catch (e, stackTrace) {
      print("❌ Error: $e");
      print("📌 StackTrace: $stackTrace");
      throw Exception("Error: $e");
    }
  }
}
