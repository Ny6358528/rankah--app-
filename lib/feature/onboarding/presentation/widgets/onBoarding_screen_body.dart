import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/onboarding/data/static_data/on_boarding_data.dart';
import 'package:rankah/feature/onboarding/logic/cubit/on_boarding_cubit.dart';
import 'package:rankah/feature/onboarding/presentation/widgets/onBoarding_screen_body_item.dart';

class OnBoardingScreenBody extends StatelessWidget {
  const OnBoardingScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: context.read<OnBoardingCubit>().pageController,
      onPageChanged: (index) {},
      itemCount: onboardingDataList.length,
      itemBuilder: (context, index) =>
          OnBoardingScreenBodyItem(onboardingModel: onboardingDataList[index]),
    );
  }
}
