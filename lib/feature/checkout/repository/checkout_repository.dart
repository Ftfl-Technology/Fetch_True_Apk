import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/checkout_model.dart';

class CheckOutRepository {
  final Dio _dio = OldApiClient.dio;

  Future<CheckOutModel?> checkout(CheckOutModel model) async {
    try {
      final response = await _dio.post(ApiUrls.checkout, data: model.toJson());
      final data = response.data?['data'];
      return data != null ? CheckOutModel.fromJson(data) : null;
    } on DioException catch (e) {
      print("DioException: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }
}
