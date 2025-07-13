// handel_dio_exception.dart
import 'package:dio/dio.dart';
import 'package:rankah/core/errors/exceptions.dart';

dynamic handelDioException(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    throw DeadlineExceededException();
  } else if (error.type == DioExceptionType.badResponse) {
    final responseData = error.response?.data;

    String? message;

    if (responseData is Map && responseData['error'] is Map) {
      message = responseData['error']['description']?.toString();
    }

    switch (error.response?.statusCode) {
      case 400:
        throw BadRequestException(message ?? "Bad request.");
      case 401:
        throw UnauthorizedException(message ?? "Unauthorized access.");
      case 404:
        throw NotFoundException(message ?? "Resource not found.");
      case 409:
        throw ConflictException(message ?? "Conflict occurred.");
      case 500:
        throw InternalServerErrorException(message ?? "Server error.");
      default:
        throw UnknownException(message ?? "Something went wrong.");
    }
  } else if (error.type == DioExceptionType.cancel) {
    throw RequestCancelledException();
  } else {
    throw NoInternetConnectionException();
  }
}
