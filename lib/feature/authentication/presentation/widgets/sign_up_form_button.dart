import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/functions/app_regex.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/authentication/data/model/SignUpModel.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_cubit.dart';

class SignUpFormButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
   final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> signUpFormKey;
  const SignUpFormButton({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.signUpFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppMaterialButton(
        onPressed: () {
          if (signUpFormKey.currentState!.validate()) {
            if (!AppRegex.isEmailValid(emailController.text.trim())) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid email'),
                ),
              );
            } else if (!AppRegex.isPasswordValid(
                passwordController.text.trim())) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Please enter a valid password with at least 8 characters, including uppercase, lowercase, number, and special character'),
                ),
              );
            } else if (passwordController.text.trim() !=
                confirmPasswordController.text.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Passwords do not match with confirm password , please try again'),
                ),
              );
            } else {
              context.read<SignUpCubit>().signUp(
                    signUpModel: SignUpModel(
                      fullname: nameController.text.trim(),
                      email: emailController.text.trim(),
                      phoneNumber: phoneController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill in all fields'),
              ),
            );
          }
        },
        buttonString: "Sign Up",
        color: AppColors.primaryColor);
  }
}
