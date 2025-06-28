import 'package:rankah/core/api/dio_consumer.dart';
import 'package:rankah/core/helpers/tokenStorage.dart';
import 'package:rankah/feature/authentication/data/model/SignUpModel.dart';
import 'package:rankah/feature/authentication/data/repo/authRepo.dart';

class AuthRepoImp implements AuthRepo {
  final DioConsumer apiConsumer;

  AuthRepoImp({required this.apiConsumer});

  @override
  Future<void> login({required String email, required String password}) async {
    final response = await apiConsumer.post(
      'https://raknah.runasp.net/Auth/login',
      body: {'email': email, 'password': password},
    );

    final token = response['token'];
    final refreshToken = response['refreshToken'];

    await TokenStorage.saveToken(token);
    await TokenStorage.saveRefreshToken(refreshToken);
  }

  @override
  Future<void> register({required SignUpModel signUpModel}) async {
    final response = await apiConsumer.post(
      'https://raknah.runasp.net/Auth/register',
      body: signUpModel.toJson(),
    );

    final token = response['token'];
    final refreshToken = response['refreshToken'];

    await TokenStorage.saveToken(token);
    await TokenStorage.saveRefreshToken(refreshToken);
  }
}
