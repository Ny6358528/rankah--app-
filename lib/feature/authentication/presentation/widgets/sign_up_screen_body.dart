import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app.assets.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/authentication/presentation/widgets/sign_up_form_button.dart';
import 'package:rankah/feature/authentication/presentation/widgets/sign_up_screen_form.dart';

class SignUpScreenBody extends StatefulWidget {
  const SignUpScreenBody({
    super.key,
  });

  @override
  State<SignUpScreenBody> createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<SignUpScreenBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Image.asset(
          AppAssets.authImage,
        ),
        Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: RPadding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 10.h,
                  children: [
                    SignUpScreenForm(
                      nameController: nameController,
                      phoneController: phoneController,
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      signUpFormKey: signUpFormKey,
                    ),
                    SignUpFormButton(
                        nameController: nameController,
                        phoneController: phoneController,
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                        signUpFormKey: signUpFormKey),
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Already have an account ? Login",
                          style: appTextStyleWithColor(
                              fontSize: AppFontSize.s12,
                              fontColor: AppColors.primaryColor),
                        )),
                  ],
                ))),
        SizedBox(
          height: 100.h,
        ),
      ],
    ));
  }
}
