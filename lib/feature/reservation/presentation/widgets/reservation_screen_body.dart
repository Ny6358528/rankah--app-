import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/utils/app.assets.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_state.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';
import 'car_plate_number.dart';
import 'reservation_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationScreenBody extends StatelessWidget {
  final int parkingSpotId;
  const ReservationScreenBody({super.key, required this.parkingSpotId});

  Future<void> _saveReservationTime(int spotId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setInt('reservation_start_$spotId', now.millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is ReservationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(' Reservation successful')),
          );
          _saveReservationTime(parkingSpotId);
          _refreshData(context);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
        } else if (state is ReservationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            spacing: 10.h,
            children: [
              Image.asset(AppAssets.reservationImage),
              Text(
                'Enter the car plate number to reserve a spot',
                style: appTextStyleWithColor(
                  fontSize: AppFontSize.s14,
                  fontColor: AppColors.fourthColor,
                ),
                textAlign: TextAlign.center,
              ),
              const CarPlateNumber(),
              if (state is ReservationLoading)
                const CircularProgressIndicator()
              else
                ReservationButton(parkingSpotId: parkingSpotId),
            ],
          ),
        );
      },
    );
  }

  void _refreshData(BuildContext context) {
    try {
      // Refresh parking spots
      context.read<HomeCubit>().refreshParkingSpots();
      // Refresh pending reservations
      context.read<PendingReservationCubit>().refreshPendingReservations();
    } catch (e) {
      debugPrint("Error refreshing data: $e");
    }
  }
}
