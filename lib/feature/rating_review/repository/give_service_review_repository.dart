import 'package:dio/dio.dart';

import '../../../helper/api_client.dart';
import '../model/give_service_review_model.dart';

class GiveServiceReviewRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ServiceReviewResponseModel> giveServiceReview(
      GiveServiceReviewModel model) async {
    try {
      Response response = await _apiClient.post(
        "/service/review",
        data: model.toJson(),
      );

      return ServiceReviewResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to submit service review: $e");
    }
  }
}
