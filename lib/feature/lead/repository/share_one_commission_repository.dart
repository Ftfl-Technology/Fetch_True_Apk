import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/share_one_commission_model.dart';

class ShareOneCommissionRepository {
  final ApiClient _apiClient = ApiClient();

  Future<ShareOneCommissionModel> fetchShareOneCommission(
      String id) async {
    try {
      final Response response =
      await _apiClient.get("${ApiUrls.shareOneCommission}/$id");

      if (response.statusCode == 200 &&
          response.data['success'] == true) {
        return ShareOneCommissionModel.fromJson(
            response.data['data']);
      } else {
        throw Exception("Failed to load commission data");
      }
    } catch (e) {
      rethrow;
    }
  }
}
