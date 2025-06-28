import 'package:flutter/material.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';

class AppMaterialButton extends StatelessWidget {
  const AppMaterialButton(
      {super.key,
      // this.textColor = AppColors.secondaryColor,
      required this.onPressed,
      required this.buttonString,
      required this.color});
  final Function() onPressed;
  final String buttonString;
  final Color color;
  // final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        elevation: 0,
        color: color,
        onPressed: onPressed,
        child: Text(buttonString,
            style: appTextStyleWithColor(
                fontSize: AppFontSize.s14,
                fontColor: AppColors.secondaryColor)));
  }
}
