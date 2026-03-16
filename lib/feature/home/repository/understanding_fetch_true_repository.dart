import 'package:dio/dio.dart';
import 'package:fetchtrue/helper/api_client.dart';
import 'package:fetchtrue/helper/api_urls.dart';
import '../model/understanding_fetch_true_model.dart';

class UnderstandingFetchTrueRepository {
  final Dio dio = OldApiClient.dio;

  Future<List<UnderstandingFetchTrueModel>> fetchData() async {

    final response = await dio.get(ApiUrls.understandingFetchTrue);

    if (response.statusCode == 200 && response.data["success"] == true) {
      final List data = response.data["data"];
      return data.map((e) => UnderstandingFetchTrueModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
