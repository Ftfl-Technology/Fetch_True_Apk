import 'dart:io';
import 'package:dio/dio.dart';
import 'api_urls.dart';

class ApiClient {
  final Dio _dio;

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal()
      : _dio = Dio(
    BaseOptions(
      baseUrl: ApiUrls.baseUrl,
      connectTimeout: const Duration(seconds: 15), // increased
      receiveTimeout: const Duration(seconds: 30), // increased
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    }
  }


  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } on SocketException {
      throw Exception("No Internet connection. Please check your network.");
    }
  }
}


/// Old Api Helper
class OldApiClient {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: ApiUrls.baseUrl, // use common baseUrl
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));
}




