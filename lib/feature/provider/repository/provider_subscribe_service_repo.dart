import '../../../helper/api_client.dart';
import '../model/provider_subscribe_service_model.dart';

class ProviderSubscribeServiceRepo {
  final ApiClient _apiClient = ApiClient();

  Future<ProviderSubscribeServiceModel> getSubscribedServices(
      String providerId) async {

    final response = await _apiClient.get(
      "provider/subscribe/$providerId",
    );

    if (response.statusCode == 200) {
      return ProviderSubscribeServiceModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load subscribed services");
    }
  }
}
