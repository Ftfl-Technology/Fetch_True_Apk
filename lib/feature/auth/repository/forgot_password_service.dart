
import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';

class ForgotPasswordService {
  Future<Response> forgotPasswordUser({
    required String mobileNumber,
    required String newPassword,
  }) async {
    try {
      final response = await OldApiClient.dio.post(ApiUrls.forgotPassword,
        data: {
          "mobileNumber": mobileNumber,
          "newPassword": newPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      throw e.response?.data['error'] ?? "Something went wrong";
    }
  }
}
