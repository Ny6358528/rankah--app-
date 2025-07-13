import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rankah/core/dependency/dependency_injection.dart';
import 'package:rankah/core/functions/navigation.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_padding.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_state.dart';
import 'package:rankah/feature/authentication/presentation/widgets/login_screen_body.dart';
import 'package:rankah/feature/home/presentation/screen/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            pushWithReplacement(context, const HomeScreen());
          }
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state is LoginLoading,
            progressIndicator: const SpinKitFadingCircle(
              color: AppColors.secondaryColor,
            ),
            child: Scaffold(
              appBar: AppBar(title: const Text('Login')),
              body: SafeArea(
                child: RPadding(
                  padding: EdgeInsets.all(AppPadding.p16),
                  child: const LoginScreenBody(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
