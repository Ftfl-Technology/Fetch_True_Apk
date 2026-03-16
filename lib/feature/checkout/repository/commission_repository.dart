import 'package:dio/dio.dart';
import '../model/commission_model.dart';

class CommissionRepository {
  static final Dio _dio = Dio();

  static Future<CommissionModel?> fetchCommission() async {
    try {
      final res = await _dio.get('https://biz-booster.vercel.app/api/commission');
      if (res.statusCode == 200 && res.data is List && res.data.isNotEmpty) {
        return CommissionModel.fromJson(res.data[0]);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}
