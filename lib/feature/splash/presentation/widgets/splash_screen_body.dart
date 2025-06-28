import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rankah/core/utils/app.assets.dart';

class SplashScreenBody extends StatelessWidget {
  const SplashScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.splashBackGround,
          fit: BoxFit.cover,
        ),
        Center(
          child: Lottie.asset(
            AppAssets.splashLottie,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
