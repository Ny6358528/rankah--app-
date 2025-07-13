import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/authentication/data/repo/authRepo.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_state.dart';
import 'package:rankah/core/errors/exceptions.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit({required this.authRepo}) : super(LoginInitial());

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginInitial());
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      await authRepo.login(email: email, password: password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginError(error: _getMessageFromException(e)));
    }
  }

  String _getMessageFromException(Object e) {
    if (e is AppException) {
      return e.toString();
    }
    return "An unexpected error occurred. Please try again.";
  }
}
