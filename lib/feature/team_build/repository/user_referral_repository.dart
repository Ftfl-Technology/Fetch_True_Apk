import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../profile/model/user_model.dart';

class UserReferralRepository {
  final Dio _dio = Dio();


   /// is correct
  Future<UserModel> getUserByReferralCode(String referralCode) async {
    final response = await _dio.get(
      '${ApiUrls.user}/referredby',
      queryParameters: {'referralCode': referralCode},
    );

    if (response.data['success'] == true) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  Future<bool> confirmReferralCode({
    required String userId,
    required String referralCode,
  }) async {
    final response = await _dio.patch(
      '${ApiUrls.user}/referredby',
      // 'https://biz-booster.vercel.app/api/users/referredby',
      data: {
        "userId": userId,
        "referralCode": referralCode,
      },
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      return true;
    } else {
      print("❌ API Error: ${response.data['message']}");
      return false;
    }
  }
}
