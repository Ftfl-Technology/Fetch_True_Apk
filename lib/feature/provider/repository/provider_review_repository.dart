// provider_review_repository.dart
import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/provider_review_model.dart';

class ProviderReviewRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ProviderReviewModel?> getProviderReviews(String providerId) async {
    try {
      final response = await _apiClient.get("${ApiUrls.providerReview}/$providerId");
      if (response.data != null) {
        return ProviderReviewModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        print("Provider Review API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("Provider Review Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}