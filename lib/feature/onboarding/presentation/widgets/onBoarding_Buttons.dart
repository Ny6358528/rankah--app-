import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_padding.dart';
import 'package:rankah/feature/onboarding/logic/cubit/on_boarding_cubit.dart';
import 'package:rankah/feature/onboarding/presentation/widgets/indicator.dart';

class OnBoardingButtons extends StatelessWidget {
  const OnBoardingButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 20.sp,
            child: IconButton(
              onPressed: () => context.read<OnBoardingCubit>().previousPage(),
              icon: Icon(Icons.arrow_back, color: AppColors.secondaryColor),
            ),
          ),
          PageIndicator(),
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 20.sp,
            child: IconButton(
              onPressed: () => context.read<OnBoardingCubit>().nextPage(),
              icon: Icon(Icons.arrow_forward, color: AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
