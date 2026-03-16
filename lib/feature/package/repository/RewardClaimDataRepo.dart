import 'package:dio/dio.dart';

import '../model/reward_claim_model.dart';

class ClaimNowDataRepository {
  final Dio _dio = Dio();

  Future<List<ClaimNowDataModel>> fetchClaimNowData() async {
    final response = await _dio.get(
      "https://api.fetchtrue.com/api/reward-management/claim-now",
    );

    if (response.statusCode == 200) {
      List data = response.data["data"];
      return data.map((e) => ClaimNowDataModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load claim-now-data");
    }
  }
}
