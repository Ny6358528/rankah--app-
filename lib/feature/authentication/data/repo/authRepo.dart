

import 'package:rankah/feature/authentication/data/model/SignUpModel.dart';


abstract class AuthRepo {
  Future<void> login({required String email, required String password});
  Future<void> register({required SignUpModel signUpModel});
}
