import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rankah/core/dependency/dependency_injection.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_padding.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_state.dart';
import 'package:rankah/feature/authentication/presentation/widgets/sign_up_screen_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignUpCubit>(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.string),
                backgroundColor: AppColors.successColor,
              ),
            );
            Navigator.pop(context);
          } else if (state is SignUpError) {
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
            inAsyncCall: state is SignUpLoading,
            progressIndicator:
                const SpinKitFadingCircle(color: AppColors.secondaryColor),
            color: AppColors.thirdColor,
            child: Scaffold(
              appBar: AppBar(title: const Text('Sign Up')),
              body: const SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppPadding.p16),
                  child: SignUpScreenBody(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
