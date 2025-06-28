import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/onboarding/data/models/onBoarding_model.dart';

class OnBoardingScreenBodyItem extends StatelessWidget {
  const OnBoardingScreenBodyItem({super.key, required this.onboardingModel});
  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.h,
      children: [
        FadeInDown(child: Image.asset(onboardingModel.image)),
        FadeInLeft(
          child: Text(onboardingModel.title,
              style: appTextStyleWithColor(
                  fontSize: AppFontSize.s36,
                  fontColor: AppColors.primaryColor,
                  fontWeight: FontWeight.bold)),
        ),
        FadeInRight(
          child: Text(
            onboardingModel.description,
            style: defaultAppTextStyle(fontSize: AppFontSize.s12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
