import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../model/provider_category_model.dart';

class ProviderCategoryRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ProviderCategoryModel>> getProviderCategories(
      String providerId) async {
    try {
      Response response = await _apiClient.get(
        "/provider/categories",
        queryParameters: {
          "providerId": providerId,
        },
      );

      List data = response.data['data'];

      return data
          .map((json) => ProviderCategoryModel.fromJson(json))
          .toList();

    } catch (e) {
      throw Exception("Error fetching provider categories: $e");
    }
  }
}
