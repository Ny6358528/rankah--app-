import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/services/service_locator.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/core/utils/app_font.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';
import 'package:rankah/feature/reservation/presentation/widgets/pending_screen_body.dart';
import 'package:rankah/feature/home/data/parking_spot_model.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  int? selectedSpotId;
  int? selectedReservationId;
  Map<int, DateTime> reservationStartTimes = {};

  @override
  void initState() {
    super.initState();
    _loadReservationTimes();
  }

  Future<void> _loadReservationTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith('reservation_start_')) {
        final spotId = int.parse(key.replaceFirst('reservation_start_', ''));
        final startTimeMillis = prefs.getInt(key);
        if (startTimeMillis != null) {
          reservationStartTimes[spotId] =
              DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
        }
      }
    }
  }

  Duration _getRemainingTime(int spotId) {
    final startTime = reservationStartTimes[spotId];
    if (startTime == null) {
      return const Duration(minutes: 15);
    }

    final now = DateTime.now();
    final elapsed = now.difference(startTime);
    final totalDuration = const Duration(minutes: 15);
    final remaining = totalDuration - elapsed;

    if (remaining.isNegative) {
      return Duration.zero;
    }

    return remaining;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is HomeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 60.sp,
                  color: AppColors.errorColor,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Error loading pending reservations',
                  style: TextStyle(
                    color: AppColors.errorColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  state.message,
                  style: TextStyle(
                    color: AppColors.fourthColor,
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<HomeCubit>().getParkingSpots();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: AppColors.secondaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is HomeSuccess) {
          // Filter reserved spots
          final pendingSpots =
              state.parkingSpots.where((spot) => spot.isReserved).toList();

          if (pendingSpots.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule_outlined,
                    size: 80.sp,
                    color: Colors.amber,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No Reserved Spots',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You don\'t have any reserved parking spots',
                    style: TextStyle(
                      color: AppColors.fourthColor,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // If a spot is selected, show its details
          if (selectedSpotId != null) {
            final remainingTime = _getRemainingTime(selectedSpotId!);
            return BlocProvider(
              create: (context) {
                final cubit = sl<ReservationCubit>();
                cubit.selectedSpotId = selectedSpotId;
                cubit.reservationId = selectedReservationId;
                return cubit;
              },
              child: Scaffold(
                appBar: AppBar(
                  title: Text('Spot ${selectedSpotId}'),
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        selectedSpotId = null;
                        selectedReservationId = null;
                      });
                    },
                  ),
                ),
                body: PendingScreenBody(timeLeft: remainingTime),
              ),
            );
          }

          // Show list of pending spots
          return Scaffold(
            appBar: AppBar(
              title: const Text('Reserved Spots'),
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
            ),
            body: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: pendingSpots.length,
              itemBuilder: (context, index) {
                final spot = pendingSpots[index];
                final spotId = index + 1; // Assuming spot ID is index + 1
                final remainingTime = _getRemainingTime(spotId);

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.amber, width: 2),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedSpotId = spotId;
                        selectedReservationId = 1; 
                      });
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_parking,
                                color: Colors.amber,
                                size: 24.sp,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  spot.name,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'Reserved',
                                  style: TextStyle(
                                    color: Colors.amber[700],
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.amber,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Time Remaining:',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.fourthColor,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              SlideCountdown(
                                duration: remainingTime,
                                onDone: () {
                                  // Handle timeout
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Reservation for ${spot.name} has expired'),
                                      backgroundColor: AppColors.errorColor,
                                    ),
                                  );
                                },
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Tap to view details and manage reservation',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.fourthColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
