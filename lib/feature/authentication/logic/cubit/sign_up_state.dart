// sign_up_state.dart

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final String string;
  SignUpSuccess(this.string);
}

class SignUpError extends SignUpState {
  final String error;
  SignUpError(this.error);
}