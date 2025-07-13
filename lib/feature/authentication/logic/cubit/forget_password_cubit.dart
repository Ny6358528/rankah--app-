// forgot_password_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/authentication/logic/cubit/forget_password_state.dart';
import '../../data/repo/forgot_password_repository.dart';
import 'package:rankah/core/errors/exceptions.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository repository;

  ForgotPasswordCubit(this.repository) : super(ForgotPasswordInitial());

  Future<void> sendEmail(String email) async {
    emit(ForgotPasswordLoading());
    try {
      await repository.sendEmail(email);
      emit(SendEmailSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(_getMessageFromException(e)));
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(ForgotPasswordLoading());
    try {
      await repository.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ForgotPasswordFailure(_getMessageFromException(e)));
    }
  }

  String _getMessageFromException(Object e) {
    if (e is AppException) {
      return e.toString();
    }
    return "An unexpected error occurred. Please try again.";
  }
}
