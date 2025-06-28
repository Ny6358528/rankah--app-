import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

enum AppFont {
  ClashDisplay,
  Cairo;
}

class AppFontSize {
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s26 = 26.0;
  static const double s28 = 28.0;
  static const double s30 = 30.0;
  static const double s32 = 32.0;
  static const double s34 = 34.0;
  static const double s36 = 36.0;
  static const double s38 = 38.0;
  static const double s40 = 40.0;
}

TextStyle appTextStyleWithColor({
  required double fontSize,
  required Color fontColor,
  FontWeight? fontWeight
}) {
  return TextStyle(
    color: fontColor,
    fontSize: fontSize.sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    fontFamily:  AppFont.ClashDisplay.name
       
  );
}

TextStyle defaultAppTextStyle({
  required double fontSize,
  FontWeight? fontWeight,
}) {
  return TextStyle(
    fontSize: fontSize.sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    fontFamily:  AppFont.ClashDisplay.name
  );
}
