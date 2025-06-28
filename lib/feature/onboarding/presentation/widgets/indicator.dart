import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_padding.dart';
import 'package:rankah/feature/onboarding/data/static_data/on_boarding_data.dart';
import 'package:rankah/feature/onboarding/logic/cubit/on_boarding_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RPadding(
      padding: EdgeInsets.all(AppPadding.p16),
      child: SmoothPageIndicator(
        controller: context.read<OnBoardingCubit>().pageController,
        count: onboardingDataList.length,
        effect: JumpingDotEffect(
          dotWidth: MediaQuery.of(context).size.width * 0.02,
          dotHeight: MediaQuery.of(context).size.width * 0.02,
          activeDotColor: AppColors.primaryColor,
          dotColor: AppColors.fourthColor,
        ),
      ),
    );
  }
}
