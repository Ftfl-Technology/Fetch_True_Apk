import 'package:fetchtrue/helper/api_urls.dart';

import '../../../../helper/api_client.dart';
import '../model/franchise_model.dart';

class FranchiseRepository {
  final ApiClient _apiClient = ApiClient();

  Future<FranchiseModelResponse> fetchFranchiseModel(
      String serviceId) async {
    try {
      final response = await _apiClient.get(ApiUrls.franchiseModel,
        queryParameters: {'serviceId': serviceId},
      );

      return FranchiseModelResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching franchise model: $e');
    }
  }
}
