import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rankah/feature/onboarding/presentation/screen/onBoarding_screen.dart';
import 'package:rankah/feature/splash/presentation/widgets/splash_screen_body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: Future.delayed(
        const Duration(milliseconds: 3000),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreenBody();
        } else {
          return const OnboardingScreen();
        }
      },
    )); // FutureBuilder
  }
}
