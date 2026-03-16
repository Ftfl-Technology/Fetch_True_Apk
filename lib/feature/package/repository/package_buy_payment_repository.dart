import 'package:dio/dio.dart';
import '../model/package_buy_payment_model.dart';
import '../model/package_buy_payment_response_model.dart';

class PackageBuyPaymentRepository {
  final Dio _dio = Dio();
  final String _baseUrl = "https://api.fetchtrue.com/api/pay-u/create-payment-link";

  Future<PackageBuyPaymentResponseModel> createPaymentLink(
      PackageBuyPaymentModel model) async {
    try {
      final response = await _dio.post(_baseUrl, data: model.toJson());
      return PackageBuyPaymentResponseModel.fromJson(response.data);
    } on DioError catch (e) {
      throw Exception("Payment link creation failed: ${e.message}");
    }
  }
}
