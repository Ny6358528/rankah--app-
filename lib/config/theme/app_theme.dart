import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app_border_radius.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';

ThemeData lightMode() {
  return ThemeData(
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        closeIconColor: AppColors.secondaryColor,
        backgroundColor: AppColors.thirdColor.withOpacity(.5),
        contentTextStyle: appTextStyleWithColor(
            fontSize: AppFontSize.s14, fontColor: AppColors.secondaryColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.pR5)),
        actionTextColor: AppColors.primaryColor,
        showCloseIcon: true,
        dismissDirection: DismissDirection.down,
        disabledActionTextColor: AppColors.secondaryColor,
        actionOverflowThreshold: 0.5,
        actionBackgroundColor: AppColors.primaryColor,
        disabledActionBackgroundColor: AppColors.secondaryColor,
        elevation: 10,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
      ),
      brightness: Brightness.light,
      fontFamily: AppFont.ClashDisplay.name,
      primaryColor: AppColors.primaryColor,
      colorScheme: ColorScheme.fromSeed(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          seedColor: AppColors.primaryColor),
      useMaterial3: false,
      tooltipTheme: TooltipThemeData(
        textStyle: appTextStyleWithColor(
            fontSize: AppFontSize.s14, fontColor: AppColors.secondaryColor),
        decoration: BoxDecoration(
            color: AppColors.mediumGreyColor,
            borderRadius: BorderRadius.circular(AppBorderRadius.pR5)),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: AppColors.secondaryColor,
              textStyle: appTextStyleWithColor(
                  fontSize: AppFontSize.s14,
                  fontColor: AppColors.secondaryColor))),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        color: AppColors.primaryColor,
        titleTextStyle: appTextStyleWithColor(
            fontSize: AppFontSize.s16, fontColor: AppColors.secondaryColor),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.fourthColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: appTextStyleWithColor(
            fontSize: AppFontSize.s12, fontColor: AppColors.primaryColor),
        unselectedLabelStyle: appTextStyleWithColor(
            fontSize: AppFontSize.s10, fontColor: AppColors.fourthColor),
      ),
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.transparentColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.pR20),
                  topRight: Radius.circular(AppBorderRadius.pR20)))),
      iconTheme: const IconThemeData(color: AppColors.secondaryColor),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: AppColors.primaryColor,
          selectionHandleColor: AppColors.primaryColor),
      buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.pR10)),
          height: 45.h),
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: defaultAppTextStyle(fontSize: AppFontSize.s14),
          labelStyle: appTextStyleWithColor(
              fontSize: AppFontSize.s14, fontColor: AppColors.fourthColor),
          filled: true,
          fillColor: AppColors.lightGreyColor,
          counterStyle: appTextStyleWithColor(
              fontSize: AppFontSize.s10, fontColor: AppColors.fourthColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.pR10)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppBorderRadius.pR10,
              ),
              borderSide: const BorderSide(color: AppColors.fourthColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppBorderRadius.pR10,
              ),
              borderSide: const BorderSide(color: AppColors.fourthColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.pR10),
              borderSide: const BorderSide(color: AppColors.errorColor)),
          errorStyle: appTextStyleWithColor(
              fontSize: AppFontSize.s10,
              fontColor: AppColors.errorColor,
              fontWeight: FontWeight.bold)));
}
