import 'package:flutter/material.dart';
import 'package:rankah/core/components/models/text_felid_form_model.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.textFelidFormModel,
  });
  final TextFelidFormModel textFelidFormModel;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onTapOutside: (textField) =>
            FocusManager.instance.primaryFocus?.unfocus(),
        controller: textFelidFormModel.controller,
        obscureText: textFelidFormModel.obscureText ?? false,
        decoration: InputDecoration(
          hintText: textFelidFormModel.hintText,
          labelText: textFelidFormModel.labelText,
          prefixIcon: Icon(textFelidFormModel.prefixIcon,
              color: AppColors.primaryColor),
          suffixIcon: textFelidFormModel.suffixIcon != null
              ? IconButton(
                  onPressed: textFelidFormModel.suffixOnPressed,
                  icon: Icon(textFelidFormModel.suffixIcon,
                      color: AppColors.primaryColor))
              : null,
        ),
        style: appTextStyleWithColor(
            fontSize: AppFontSize.s14, fontColor: AppColors.thirdColor),
        keyboardType: textFelidFormModel.textInputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '${textFelidFormModel.labelText} is required';
          }
          return null;
        });
  }
}
