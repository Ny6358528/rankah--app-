import 'package:dio/dio.dart';
import 'package:rankah/core/helpers/tokenStorage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor({required this.dio});

  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken != null) {
        try {
          final response = await dio.post(
            'https://raknah.runasp.net/Auth/refresh-token',
            data: {"refreshToken": refreshToken},
          );

          final newToken = response.data['token'];
          final newRefreshToken = response.data['refreshToken'];

          await TokenStorage.saveToken(newToken);
          await TokenStorage.saveRefreshToken(newRefreshToken);

          _isRefreshing = false;

       
          final options = err.requestOptions;
          options.headers["Authorization"] = "Bearer $newToken";

          final retryResponse = await dio.fetch(options);
          return handler.resolve(retryResponse);
        } catch (e) {
          _isRefreshing = false;
          return handler.reject(err);
        }
      }
    }

    return handler.next(err);
  }
}
