import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/components/widgets/app_material_button.dart';
import 'package:rankah/core/utils/app.assets.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/history/logic/cubit/history_cubit.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_state.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';
import 'package:slide_countdown/slide_countdown.dart';

class PendingScreenBody extends StatefulWidget {
  final Duration timeLeft;
  const PendingScreenBody({super.key, required this.timeLeft});

  @override
  State<PendingScreenBody> createState() => _PendingScreenBodyState();
}

class _PendingScreenBodyState extends State<PendingScreenBody> {
  Duration duration = const Duration(minutes: 15);
  bool isLastFiveMinutes = false;
  bool isTimerFinished = false;
  bool reservationCancelled = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReservationCubit>();
    final int? parkingSpotId = cubit.selectedSpotId;
    final int? reservationId = cubit.reservationId;

    if (parkingSpotId == null || reservationId == null) {
      return const Center(
        child: Text(
          " No reservation data found",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return BlocConsumer<ReservationCubit, ReservationState>(
      listener: (context, state) {
        if (state is OpenGateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gate opened successfully')),
          );
          _safeUpdateHistory(context);
        } else if (state is CancelReservationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reservation cancelled successfully')),
          );
          setState(() => reservationCancelled = true);
          _safeUpdateHistory(context);
         
          try {
            context
                .read<PendingReservationCubit>()
                .refreshPendingReservations();
          } catch (_) {}
     
          Future.delayed(const Duration(milliseconds: 600), () {
            Navigator.of(context).popUntil((route) => route.isFirst);
    
            Future.delayed(const Duration(milliseconds: 200), () {
              try {
                context.read<HomeCubit>().refreshParkingSpots();
              } catch (_) {}
            });
          });
        } else if (state is OpenGateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is CancelReservationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Image.asset(AppAssets.pendingImage),
            SizedBox(height: 16.h),

            // Countdown Timer
            if (!isTimerFinished && !reservationCancelled)
              SlideCountdown(
                duration: widget.timeLeft,
                onDone: () {
                  setState(() {
                    isTimerFinished = true;
                  });
                  if (cubit.reservationId != null) {
                    cubit.cancelReservation(cubit.reservationId!);
                  }
                },
                onChanged: (remaining) {
                  if (remaining.inMinutes <= 5 && !isLastFiveMinutes) {
                    setState(() {
                      isLastFiveMinutes = true;
                    });
                  }
                },
                separatorType: SeparatorType.title,
                decoration: BoxDecoration(
                  color: isLastFiveMinutes
                      ? AppColors.errorColor
                      : AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                icon: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.access_time, color: Colors.white),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  " Reservation expired or cancelled",
                  style: TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 24),

            // Action Buttons
            if (!reservationCancelled && !isTimerFinished)
              if (state is OpenGateLoading || state is CancelReservationLoading)
                const CircularProgressIndicator()
              else ...[
                AppMaterialButton(
                  onPressed: () => cubit.openGate(parkingSpotId),
                  buttonString: "Open Gate",
                  color: AppColors.successColor,
                ),
                AppMaterialButton(
                  onPressed: () => cubit.cancelReservation(reservationId),
                  buttonString: "Cancel Reservation",
                  color: AppColors.primaryColor,
                ),
              ],
          ],
        );
      },
    );
  }

  void _safeUpdateHistory(BuildContext context) {
    try {
      context.read<HistoryCubit>().fetchAllReservations();
    } catch (e) {
      debugPrint("HistoryCubit not found in context: $e");
    }
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
