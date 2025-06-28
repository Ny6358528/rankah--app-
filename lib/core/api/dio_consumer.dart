import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rankah/core/api/api_consumer.dart';
import 'package:rankah/core/api/api_interceptors.dart';
import 'package:rankah/core/errors/handelDioException.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    print('DioConsumer initialized');
    dio.interceptors.add(AuthInterceptor(dio: dio));
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  @override
  Future<dynamic> delete(String url) async {
    try {
      final response = await dio.delete(url);
      return response.data;
    } on DioException catch (e) {
      throw handelDioException(e);
    }
  }

  @override
  Future<dynamic> get(String url) async {
    try {
      print('DioConsumer: Making GET request to $url');
      final response = await dio.get(url);
      print('DioConsumer: GET request successful, response: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('DioConsumer: GET request failed with DioException: $e');
      throw handelDioException(e);
    } catch (e) {
      print('DioConsumer: GET request failed with general exception: $e');
      throw Exception('Network request failed: $e');
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    bool isFormData = false,
    required Map<String, dynamic> body,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: isFormData ? FormData.fromMap(body) : body,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      throw handelDioException(e);
    }
  }

  @override
  Future<dynamic> put(String url, {required Map<String, dynamic> body}) async {
    try {
      final response = await dio.put(url, data: body);
      return response.data;
    } on DioException catch (e) {
      throw handelDioException(e);
    }
  }
}
