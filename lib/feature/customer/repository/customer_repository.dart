import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../core/costants/custom_log_emoji.dart';
import '../../../helper/api_client.dart';
import '../model/add_customer_model.dart';
import '../../../helper/api_urls.dart';
import '../model/customer_model.dart';

class CustomerRepository {
  final ApiClient _apiClient = ApiClient();

  /// Create a new customer
   Future<AddCustomerModel?> createCustomer(AddCustomerModel addCustomer) async {
    try {
      final response = await _apiClient.post(
        ApiUrls.serviceCustomer,
        data: addCustomer.toFormData(),
      );
      if (response.data["success"] == true) {
        return AddCustomerModel.fromJson(response.data["data"]);
      } else {
        final errorMessage = response.data["message"] ?? "Something went wrong";
        throw errorMessage;
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? "Unknown error";
        debugPrint("${CustomLogEmoji.error} Customer API Error [${e.response?.statusCode}]: $errorMessage",);
      }
      else {
        errorMessage = e.message ?? "Network Error";
        debugPrint("${CustomLogEmoji.network} Register Network Error: $errorMessage",);
      }
      throw errorMessage;
    }
  }

  /// Fetch all customers
  Future<List<CustomerModel>> getCustomers() async {
    try {
      final response = await _apiClient.get(ApiUrls.serviceCustomer);

      if (response.data["success"] == true) {
        final List<dynamic> data = (response.data["data"] as List?) ?? [];
        return data.map((json) => CustomerModel.fromJson(json)).toList();
      } else {
        final errorMessage = response.data["message"] ?? "Something went wrong";
        throw errorMessage;
      }
    } on DioException catch (e) {
      String errorMessage = "Something went wrong";
      if (e.response != null) {
        errorMessage = e.response?.data['message'] ?? "Unknown error";
        debugPrint(
          "${CustomLogEmoji.error} Get Customers API Error [${e.response?.statusCode}]: $errorMessage",
        );
      } else {
        errorMessage = e.message ?? "Network Error";
        debugPrint(
          "${CustomLogEmoji.network} Get Customers Network Error: $errorMessage",
        );
      }
      throw errorMessage;
    }
  }

}
