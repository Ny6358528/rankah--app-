import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/components/models/text_felid_form_model.dart';
import 'package:rankah/core/components/widgets/app_text_form_field.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_state.dart';

class LoginScreenForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey;

  const LoginScreenForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.loginFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          AppTextFormField(
            textFelidFormModel: TextFelidFormModel(
              labelText: 'Email',
              prefixIcon: Icons.email,
              textInputType: TextInputType.emailAddress,
              hintText: 'Enter your email',
              controller: emailController,
            ),
          ),
          SizedBox(height: 12.h),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              final cubit = context.read<LoginCubit>();
              return AppTextFormField(
                textFelidFormModel: TextFelidFormModel(
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: !cubit.isPasswordVisible,
                  textInputType: TextInputType.visiblePassword,
                  hintText: 'Enter your password',
                  controller: passwordController,
                  suffixOnPressed: cubit.togglePasswordVisibility,
                  suffixIcon: cubit.isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
