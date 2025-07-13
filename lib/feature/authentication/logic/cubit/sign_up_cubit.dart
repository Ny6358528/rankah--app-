import 'package:bloc/bloc.dart';
import 'package:rankah/feature/authentication/data/model/SignUpModel.dart';
import 'package:rankah/feature/authentication/data/repo/authRepo.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_state.dart';
import 'package:rankah/core/errors/exceptions.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepo authRepo;

  SignUpCubit({required this.authRepo}) : super(SignUpInitial());

  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(SignUpInitial());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(SignUpInitial());
  }

  Future<void> signUp({required SignUpModel signUpModel}) async {
    emit(SignUpLoading());
    try {
      await authRepo.register(signUpModel: signUpModel);
      emit(SignUpSuccess("Account created successfully"));
    } catch (e) {
      emit(SignUpError(_getMessageFromException(e)));
    }
  }

  String _getMessageFromException(Object e) {
    if (e is AppException) {
      return e.toString();
    }
    return "An unexpected error occurred. Please try again.";
  }
}
