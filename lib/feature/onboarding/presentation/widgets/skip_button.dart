import 'package:flutter/material.dart';
import 'package:rankah/core/functions/navigation.dart';
// import 'package:rankah/feature/authentication/login.dart';
import 'package:rankah/feature/authentication/presentation/screen/login_screen.dart';

class SkipButton extends StatelessWidget {
  const SkipButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => pushWithReplacement(context, LoginScreen()),
        child: Text("Skip"));
  }
}
