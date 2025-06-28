import 'package:bloc/bloc.dart';
import 'profile_state.dart';
import '../../data/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  String? fullName;
  String? phoneNumber;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(ProfileInitial());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(ProfileInitial());
  }

  Future<void> updateProfileInfo({
    required String name,
    required String phone,
  }) async {
    emit(ProfileLoading());
    try {
      await repository.updateProfileInfo(name: name, phone: phone);
      fullName = name;
      phoneNumber = phone;
      emit(ProfileInfoUpdated());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ProfileLoading());
    try {
      await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      emit(PasswordChangedSuccessfully());
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }
}
