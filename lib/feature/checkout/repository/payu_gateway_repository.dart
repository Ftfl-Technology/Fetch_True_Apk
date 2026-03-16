import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/payu_gateway_model.dart';
import '../model/payu_gateway_response_model.dart';

class PayUGatewayRepository {
  final ApiClient _api = ApiClient();

  Future<PayUGatewayResponseModel?> initiatePayment(PayUGatewayModel data) async {
    try {
      final res = await _api.post(ApiUrls.payuGatewayUrl, data: data.toJson());
      if (res.statusCode == 200 || res.statusCode == 201) {
        return PayUGatewayResponseModel.fromJson(res.data);
      }
    } catch (e) {
      print("PayU Error: $e");
    }
    return null;
  }
}
