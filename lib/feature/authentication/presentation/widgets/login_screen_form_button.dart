import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/functions/app_regex.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_cubit.dart';

class LoginScreenFormButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey;

  const LoginScreenFormButton({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.loginFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return AppMaterialButton(
      onPressed: () {
        if (loginFormKey.currentState!.validate()) {
          if (!AppRegex.isEmailValid(emailController.text.trim())) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a valid email')),
            );
          } else if (!AppRegex.isPasswordValid(passwordController.text.trim())) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Password must include upper/lowercase, number, and special char')),
            );
          } else {
            context.read<LoginCubit>().loginUser(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')),
          );
        }
      },
      buttonString: "Login",
      color: AppColors.primaryColor,
    );
  }
}
