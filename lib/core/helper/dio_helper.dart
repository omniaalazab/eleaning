import 'package:dio/dio.dart';
import 'package:eleaning/core/constants/api_keys.dart';

class DioHelper {
  static late Dio _dio;

  static Future<Response> post(String baseUrl, Map<String, dynamic> data) {
    BaseOptions options = BaseOptions(
      headers: {
        'Authorization': 'Bearer ${ApiKeys.stripeSecretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    _dio = Dio(options);
    return _dio.post(baseUrl, data: data);
  }
}
