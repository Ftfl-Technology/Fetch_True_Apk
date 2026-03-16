import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/wallet_model.dart';

class WalletRepository {
  final ApiClient _apiClient = ApiClient();

  Future<WalletModel> getWallet(String userId) async {
    try {
      final response = await _apiClient.get("${ApiUrls.wallet}/$userId");
      final result = WalletModel.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      if (e.response != null) {
        print("Wallet API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("Wallet Network Error: ${e.message}");
      }
      rethrow;
    }
  }
}