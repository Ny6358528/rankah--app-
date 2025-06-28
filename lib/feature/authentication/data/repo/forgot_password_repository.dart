// forgot_password_repository.dart
import 'package:dio/dio.dart';

class ForgotPasswordRepository {
  final Dio dio;
  ForgotPasswordRepository(this.dio);

  Future<void> sendEmail(String email) async {
    await dio.post('/Auth/forget-password', data: {"email": email});
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await dio.post('/Auth/reset-password', data: {
      "email": email,
      "code": code,
      "newPassword": newPassword,
    });
  }
}
