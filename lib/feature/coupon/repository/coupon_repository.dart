import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/coupon_model.dart';

class CouponRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<CouponModel>> fetchCouponsByUser({
    required String userId,
    required String serviceId,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _apiClient.get('${ApiUrls.coupon}/user/$userId',
          queryParameters: {
            "serviceId": serviceId,
            "lat": lat,
            "lng": lng,
          });

      if (response.statusCode == 200) {
        final couponResponse = CouponResponse.fromJson(response.data);
        return couponResponse.coupons;
      } else if (response.statusCode == 404) {
        // No coupons for this user/service
        return [];
      } else {
        throw Exception('Failed to load coupons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coupons: $e');
    }
  }
}