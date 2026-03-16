import 'package:dio/dio.dart';

class RewardClaimRepository {
  final Dio dio = Dio();

  Future<String> submitClaim({
    required String userId,
    required String rewardId,
    required int selectedIndex,
  }) async {
    final url = "https://api.fetchtrue.com/api/reward-management/claim-now";

    final data = {
      "user": userId,
      "reward": rewardId,
      if (selectedIndex == 0) "isClaimRequest": true,
      if (selectedIndex == 1) "isExtraMonthlyEarnRequest": true,
    };

    print("🚀 REQUEST BODY => $data");

    try {
      final response = await dio.post(url, data: data);

      print("📩 RESPONSE => ${response.data}");

      // ---- Success Response ----
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data["success"] == true) {
          return response.data["message"] ?? "Request Submitted Successfully!";
        } else {
          throw (response.data["message"] ?? "Failed! Try again.");
        }
      }
      // ---- If status not success ----
      else {
        throw "HTTP Error: ${response.statusCode}";
      }
    } catch (e) {
      print("❌ EXCEPTION => $e");
      throw "Error: $e";
    }
  }

}
