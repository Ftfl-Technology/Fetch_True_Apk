import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/favorite_provider_model.dart';
import '../model/favorite_services_model.dart';

class FavoriteServiceRepository {
  final Dio _dio = OldApiClient.dio;

  Future<FavoriteResponse> addToFavorite(String userId, String serviceId) async {
    try {
      final response = await _dio.put(
        '${ApiUrls.user}/favourite-services/$userId/$serviceId',
      );

      if (response.statusCode == 200) {
        return FavoriteResponse.fromJson(response.data);
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Something went wrong");
    }
  }

  Future<FavoriteResponse> removeFromFavorite(String userId, String serviceId) async {
    try {
      final response = await _dio.delete(
        '${ApiUrls.user}/favourite-services/$userId/$serviceId',
      );

      if (response.statusCode == 200) {
        return FavoriteResponse.fromJson(response.data);
      } else {
        throw Exception("Failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Something went wrong");
    }
  }
}
