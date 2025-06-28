// dio_helper.dart
import 'package:dio/dio.dart';
import 'package:rankah/core/helpers/tokenStorage.dart';

class DioHelper {
  static late Dio dio;

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://raknah.runasp.net',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getToken();
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          print(" Requesting: ${options.baseUrl}${options.path}");
          print(" Headers: ${options.headers}");
          print(" Data: ${options.data}");

          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print(" Dio Error: ${e.response?.statusCode} ${e.response?.data}");
          return handler.next(e);
        },
      ),
    );
  }
}
