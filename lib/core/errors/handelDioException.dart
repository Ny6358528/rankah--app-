import 'package:dio/dio.dart';
import 'package:rankah/core/errors/exceptions.dart';

dynamic handelDioException(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    throw DeadlineExceededException();
  } else if (error.type == DioExceptionType.badResponse) {
    switch (error.response?.statusCode) {
      case 400:
        throw BadRequestException(error.response?.data.toString());
      case 401:
        throw UnauthorizedException(error.response?.data.toString());
      case 404:
        throw NotFoundException(error.response?.data.toString());
      case 409:
        throw ConflictException(error.response?.data.toString());
      case 500:
        throw InternalServerErrorException(error.response?.data.toString());
      default:
        throw UnknownException(error.message);
    }
  } else if (error.type == DioExceptionType.cancel) {
    throw RequestCancelledException();
  } else {
    throw NoInternetConnectionException();
  }
}
