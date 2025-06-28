import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/components/models/text_felid_form_model.dart';
import 'package:rankah/core/components/widgets/app_text_form_field.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_state.dart';

class SignUpScreenForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> signUpFormKey;
  const SignUpScreenForm({
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
    return Form(
      key: signUpFormKey,
      child: Column(
        spacing: 10.h,
        children: [
          AppTextFormField(
              textFelidFormModel: TextFelidFormModel(
            labelText: 'User Name',
            prefixIcon: Icons.person,
            textInputType: TextInputType.text,
            hintText: 'Enter your name',
            controller: nameController,
          )),
          AppTextFormField(
              textFelidFormModel: TextFelidFormModel(
            labelText: 'Email',
            prefixIcon: Icons.email,
            textInputType: TextInputType.emailAddress,
            hintText: 'Enter your email',
            controller: emailController,
          )),
          AppTextFormField(
              textFelidFormModel: TextFelidFormModel(
            labelText: 'Phone',
            prefixIcon: Icons.phone,
            textInputType: TextInputType.phone,
            hintText: 'Enter your phone',
            controller: phoneController,
          )),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return AppTextFormField(
                  textFelidFormModel: TextFelidFormModel(
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: context.read<SignUpCubit>().isPasswordVisible,
                textInputType: TextInputType.visiblePassword,
                hintText: 'Enter your password',
                controller: passwordController,
                suffixOnPressed: () =>
                    context.read<SignUpCubit>().togglePasswordVisibility(),
                suffixIcon: context.read<SignUpCubit>().isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ));
            },
          ),
          BlocBuilder<SignUpCubit, SignUpState>(
            builder: (context, state) {
              return AppTextFormField(
                  textFelidFormModel: TextFelidFormModel(
                labelText: 'Confirm Password',
                prefixIcon: Icons.lock,
                obscureText:
                    context.read<SignUpCubit>().isConfirmPasswordVisible,
                textInputType: TextInputType.visiblePassword,
                hintText: 'Enter your confirm password',
                controller: confirmPasswordController,
                suffixOnPressed: () => context
                    .read<SignUpCubit>()
                    .toggleConfirmPasswordVisibility(),
                suffixIcon: context.read<SignUpCubit>().isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ));
            },
          ),
        ],
      ),
    );
  }
}
