import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'reservation_screen.dart';

class ReservationSplashScreen extends StatelessWidget {
  final int parkingSpotId;
  const ReservationSplashScreen({super.key, required this.parkingSpotId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 4750)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  Lottie.asset('assets/image/Animation - 1747733166874.json'),
            );
          } else {
            return ReservationScreen(parkingSpotId: parkingSpotId);
          }
        },
      ),
    );
  }
}
