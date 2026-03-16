import 'package:dio/dio.dart';

import '../../../helper/api_client.dart';
import '../model/give_provider_review_model.dart';

class GiveProviderReviewRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ProviderReviewResponseModel> giveProviderReview(
      GiveProviderReviewModel model) async {
    try {
      Response response = await _apiClient.post(
        "/provider/review",
        data: model.toJson(),
      );

      return ProviderReviewResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to submit service review: $e");
    }
  }
}
