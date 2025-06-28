import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app.assets.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';

class HomeScreenBodyPictures extends StatelessWidget {
  const HomeScreenBodyPictures({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: Row(
            spacing: 5.w,
            children: [
              Expanded(
                  flex: 2,
                  child: FadeInLeft(child: Image.asset(AppAssets.homeImage1))),
              Expanded(
                flex: 1,
                child: Text(
                  'Find parking, and  plan your trips with ease, and drive safely with peace of mind  with Rankah Application.',
                  style: appTextStyleWithColor(
                      fontSize: AppFontSize.s10,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.fourthColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Find parking, and  plan your trips with ease, and drive safely with peace of mind  with Rankah Application.',
                  style: appTextStyleWithColor(
                      fontSize: AppFontSize.s10,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.fourthColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: FadeIn(child: Image.asset(AppAssets.homeImage3))),
              Expanded(
                flex: 1,
                child: Text(
                  'Find parking, and  plan your trips with ease, and drive safely with peace of mind  with Rankah Application.',
                  style: appTextStyleWithColor(
                      fontSize: AppFontSize.s10,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.fourthColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: Row(
            spacing: 5.w,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  'Find parking, and  plan your trips with ease, and drive safely with peace of mind  with Rankah Application.',
                  style: appTextStyleWithColor(
                      fontSize: AppFontSize.s10,
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.fourthColor),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                  flex: 2,
                  child: FadeInRight(child: Image.asset(AppAssets.homeImage2))),
            ],
          ),
        ),
      ],
    );
  }
}
