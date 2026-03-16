import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../model/coupon_apply_model.dart';

class CouponApplyRepository {
  final ApiClient _apiClient = ApiClient();

  Future<CouponApplyResponse> applyCoupon(CouponApplyModel model) async {
    try {
      final response = await _apiClient.post(
        'coupon/apply',
        data: model.toJson(),
      );

      if (response.statusCode == 200) {
        return CouponApplyResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to apply coupon");
      }
    } on DioException catch (e) {
      throw Exception("Dio error: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Error applying coupon: $e");
    }
  }
}
