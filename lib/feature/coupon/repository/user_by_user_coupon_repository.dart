import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../model/used_by_user_coupon.dart';
import '../../../helper/api_urls.dart'; // Import ApiUrls

class UserByUserCouponRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<UsedByUserCoupon>> getUsedByUserCoupons(String userId) async {
    try {
      // Updated URL to use ApiUrls
      final response = await _apiClient.get('${ApiUrls.coupon}/used-by-user/$userId');

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => UsedByUserCoupon.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load used coupons');
      }
    } catch (e) {
      throw Exception('Error fetching used coupons: $e');
    }
  }
}