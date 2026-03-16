import 'package:dio/dio.dart';
import '../model/bank_detail_model.dart';

class BankDetailRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.fetchtrue.com/api/users/'));

  Future<BankDetailModel> fetchBankDetail(String userId) async {
    try {
      final response = await _dio.get('bank-details/$userId');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return BankDetailModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load bank detail');
      }
    } catch (e) {
      throw Exception('Error fetching bank detail: $e');
    }
  }
}
