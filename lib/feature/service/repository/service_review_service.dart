import 'package:fetchtrue/helper/api_urls.dart';
import 'package:flutter/foundation.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../../rating_review/model/service_review_model.dart';

class ReviewService {

  final ApiClient _apiClient = ApiClient();

  Future<ServiceReviewResponse?> fetchReviews(String serviceId) async {
    try {
      final response = await _apiClient.get(
        '${ApiUrls.serviceReview}/$serviceId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return ServiceReviewResponse.fromJson(response.data);
      }
    } catch (e) {
      debugPrint(
        "${CustomLogEmoji.error} Error fetching reviews: $e",
      );
    }
    return null;
  }
}
