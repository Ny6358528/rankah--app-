import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/functions/navigation.dart';
import 'package:rankah/core/services/service_locator.dart';
import 'package:rankah/core/utils/app.assets.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/authentication/logic/cubit/forget_password_cubit.dart';
import 'package:rankah/feature/authentication/presentation/screen/SendEmailScreen.dart';
import 'package:rankah/feature/authentication/presentation/screen/sign_up_screen.dart';
import 'package:rankah/feature/authentication/presentation/widgets/login_screen_form.dart';
import 'package:rankah/feature/authentication/presentation/widgets/login_screen_form_button.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  State<LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(AppAssets.authImage),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Login to your account to continue using our app',
                    style: appTextStyleWithColor(
                      fontSize: AppFontSize.s12,
                      fontColor: AppColors.fourthColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  LoginScreenForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    loginFormKey: loginFormKey,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
           onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BlocProvider<ForgotPasswordCubit>(
        create: (_) => sl<ForgotPasswordCubit>(),
        child: ForgetPasswordScreen(),
      ),
    ),
  );
},


                      child: Text(
                        "Forget Password ?",
                        style: appTextStyleWithColor(
                          fontSize: AppFontSize.s12,
                          fontColor: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  LoginScreenFormButton(
                    emailController: emailController,
                    passwordController: passwordController,
                    loginFormKey: loginFormKey,
                  ),
                  TextButton(
                    onPressed: () => pushTo(context, const SignUpScreen()),
                    child: Text(
                      "Don't have an account ? Sign up",
                      style: appTextStyleWithColor(
                        fontSize: AppFontSize.s12,
                        fontColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
