import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../../../helper/api_client.dart';
import '../model/bank_kyc_model.dart';

class BankKycRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Response> submitBankKyc(BankKycModel model) async {
    try {
      final response = await _apiClient.post(ApiUrls.bankKyc,
        data: model.toJson(),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }
}
