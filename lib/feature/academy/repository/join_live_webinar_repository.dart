import '../../../helper/api_client.dart';

class JoinLiveWebinarRepository {
  final ApiClient apiClient = ApiClient();

  Future<String> joinWebinar({
    required String webinarId,
    required List<String> users,
    required bool status,
  }) async {
    try {
      final response = await apiClient.put(
        "/academy/livewebinars/enroll/$webinarId",
        data: {
          "users": users,
          "status": status,
        },
      );

      return response.data["message"] ?? "Success";
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
