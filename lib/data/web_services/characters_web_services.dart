import 'package:breaking_bad_app/shared/constants/end_points.dart';
import 'package:dio/dio.dart';

class CharacterwsWebServices {
  Dio? dio;
  CharacterwsWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      receiveTimeout: 100 * 1000,
      sendTimeout: 20 * 1000,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> requestCharacters() async {
    try {
      Response response = await dio!.get(charactersEndPoint);
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<dynamic>> requestQuoets(String authorName) async {
    try {
      Response response = await dio!
          .get(quoteEndPoint, queryParameters: {'author': authorName});
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
