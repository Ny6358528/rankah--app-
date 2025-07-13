// exceptions.dart
class AppException implements Exception {
  final String? message;
  AppException([this.message]);

  @override
  String toString() => message ?? "Something went wrong.";
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message);
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message);
}

class ConflictException extends AppException {
  ConflictException([String? message]) : super(message);
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message]) : super(message);
}

class NoInternetConnectionException extends AppException {
  NoInternetConnectionException([String? message])
      : super(message ?? "No internet connection.");
}

class DeadlineExceededException extends AppException {
  DeadlineExceededException([String? message])
      : super(message ?? "Request timeout.");
}

class RequestCancelledException extends AppException {
  RequestCancelledException([String? message])
      : super(message ?? "Request was cancelled.");
}

class UnknownException extends AppException {
  UnknownException([String? message])
      : super(message ?? "Something went wrong.");
}
