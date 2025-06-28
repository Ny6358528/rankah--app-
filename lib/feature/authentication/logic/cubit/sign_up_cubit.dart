import 'package:bloc/bloc.dart';
import 'package:rankah/feature/authentication/data/model/SignUpModel.dart';

import 'package:rankah/feature/authentication/data/repo/authRepo.dart';
import 'package:rankah/feature/authentication/data/repo/authRepoImp.dart';

import 'sign_up_state.dart';

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
      emit(SignUpError(e.toString()));
    }
  }
}
