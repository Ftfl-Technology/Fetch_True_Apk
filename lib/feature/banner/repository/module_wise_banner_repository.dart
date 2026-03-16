import 'package:dio/dio.dart';
import '../model/module_wise_banner_model.dart';

class ModuleWiseBannerRepository {
  final Dio dio;

  ModuleWiseBannerRepository({Dio? dio})
      : dio = dio ?? Dio();

  Future<List<ModuleWiseBannerModel>> getModuleWiseBanners(
      String moduleId) async {
    try {
      final response = await dio.get(
        'https://api.fetchtrue.com/api/banner',
        queryParameters: {'module': moduleId},
      );

      final List data = response.data;

      return data
          .map((e) => ModuleWiseBannerModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Module wise banner fetch failed');
    }
  }
}
