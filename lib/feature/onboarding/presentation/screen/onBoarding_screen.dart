import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app_padding.dart';
import 'package:rankah/feature/onboarding/logic/cubit/on_boarding_cubit.dart';
import 'package:rankah/feature/onboarding/presentation/widgets/onBoarding_Buttons.dart';
import 'package:rankah/feature/onboarding/presentation/widgets/onBoarding_screen_body.dart';
import 'package:rankah/feature/onboarding/presentation/widgets/skip_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Scaffold(
          appBar: AppBar(
            actions: [SkipButton()],
          ),
          bottomSheet: OnBoardingButtons(),
          body: SafeArea(
              child: RPadding(
            padding: EdgeInsets.all(AppPadding.p16),
            child: OnBoardingScreenBody(),
          ))),
    );
  }
}
