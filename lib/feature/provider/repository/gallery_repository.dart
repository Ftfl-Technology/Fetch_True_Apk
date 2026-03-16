import 'package:dio/dio.dart';
import '../../../helper/api_client.dart';
import '../../../helper/api_urls.dart';
import '../model/gallery_model.dart';

class GalleryRepository {
  final ApiClient _apiClient = ApiClient();
  Future<GalleryModel?> getProviderGallery(String providerId) async {
    try {
      final response = await _apiClient.get('${ApiUrls.provider}/$providerId/gallery');
      if (response.data != null) {
        return GalleryModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        print("Gallery API Error [${e.response?.statusCode}]: ${e.response?.data}");
      } else {
        print("Gallery Network Error: ${e.message}");
      }
      rethrow;
    }
  }}
