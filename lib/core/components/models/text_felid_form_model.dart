import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class TextFelidFormModel {
  TextFelidFormModel({
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.textInputType,
    this.suffixIcon,
    this.suffixOnPressed,
    this.obscureText,
    this.onChanged, 
  });

  final String hintText, labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType textInputType;
  bool? obscureText;
  IconData? suffixIcon;
  Function()? suffixOnPressed;
  Function(String)? onChanged; 
}
