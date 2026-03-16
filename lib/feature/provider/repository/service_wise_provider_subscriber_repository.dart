import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/service_wise_provider_subscriber_model.dart';

class ServiceWiseProviderSubscriberRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ProviderSubscriberModel>> getServiceWiseProviderSubscriber(
      String serviceId) async {
    final Response response = await _apiClient.get(
      '${ApiUrls.serviceWiseProviders}/$serviceId',
    );

    final ServiceWiseProviderSubscriberResponse result =
    ServiceWiseProviderSubscriberResponse.fromJson(response.data);

    return result.data;
  }
}
