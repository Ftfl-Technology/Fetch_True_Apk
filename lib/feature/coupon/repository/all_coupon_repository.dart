// all_coupon_repository.dart
import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/all_coupon_model.dart';

class AllCouponRepository {
  final ApiClient _apiClient = ApiClient();

  /// Fetch all coupons from the API
  Future<AllCouponModel> getAllCoupons() async {
    try {
      final Response response = await _apiClient.get(ApiUrls.coupon);

      if (response.statusCode == 200) {
        // Convert JSON to AllCouponModel
        return AllCouponModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load coupons. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to fetch coupons: ${e.message}');
    } catch (e) {
      throw Exception('Something went wrong: $e');
    }
  }
}