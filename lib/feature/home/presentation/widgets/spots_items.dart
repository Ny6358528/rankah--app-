import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/functions/navigation.dart';
import 'package:rankah/feature/reservation/presentation/screen/reservation_splash_screen.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/data/parking_spot_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SpotsItems extends StatefulWidget {
  const SpotsItems({super.key});

  @override
  State<SpotsItems> createState() => _SpotsItemsState();
}

class _SpotsItemsState extends State<SpotsItems> {
  Map<int, DateTime> reservationStartTimes = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadReservationTimes();
    // Start timer to update UI every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // This will trigger rebuild to update remaining time
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  Future<void> _saveReservationTime(int spotId) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    reservationStartTimes[spotId] = now;
    await prefs.setInt('reservation_start_$spotId', now.millisecondsSinceEpoch);
  }

  Future<void> _removeReservationTime(int spotId) async {
    final prefs = await SharedPreferences.getInstance();
    reservationStartTimes.remove(spotId);
    await prefs.remove('reservation_start_$spotId');
  }

  Duration _getRemainingTime(int spotId) {
    final startTime = reservationStartTimes[spotId];
    if (startTime == null) {
      // If no start time saved, create one
      _saveReservationTime(spotId);
      return const Duration(minutes: 15);
    }

    final now = DateTime.now();
    final elapsed = now.difference(startTime);
    final totalDuration = const Duration(minutes: 15);
    final remaining = totalDuration - elapsed;

    if (remaining.isNegative) {
      // Time expired, remove the reservation
      _removeReservationTime(spotId);
      return Duration.zero;
    }

    return remaining;
  }

  // Helper method to get status color
  Color _getStatusColor(ParkingSpotModel spot) {
    if (spot.isAvailable) return AppColors.primaryColor;
    if (spot.isReserved) return Colors.amber; 
    if (spot.isOccupied) return Colors.red;
    return AppColors.errorColor;
  }

  // Helper method to get status text
  String _getStatusText(ParkingSpotModel spot) {
    if (spot.isAvailable) return 'Available';
    if (spot.isReserved) return 'Reserved';
    if (spot.isOccupied) return 'Occupied';
    return 'Unknown';
  }

  // Helper method to get status icon
  IconData _getStatusIcon(ParkingSpotModel spot) {
    if (spot.isAvailable) return Icons.local_parking;
    if (spot.isReserved) return Icons.schedule;
    if (spot.isOccupied) return Icons.block;
    return Icons.help_outline;
  }

  // Helper method to check if spot is clickable
  bool _isClickable(ParkingSpotModel spot) {
    return spot
        .isAvailable; // Only available spots are clickable in home screen
  }

  // Helper method to handle navigation
  void _handleNavigation(
      BuildContext context, ParkingSpotModel spot, int index) {
    if (spot.isAvailable) {
      // Navigate to reservation page (car plate)
      pushTo(context, ReservationSplashScreen(parkingSpotId: index + 1));
    }
    // Removed the else if (spot.isReserved) block - no navigation for reserved spots in home screen
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Loading parking spots...',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
                  'Error loading parking spots',
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
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: state.parkingSpots.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final spot = state.parkingSpots[index];
              final statusColor = _getStatusColor(spot);
              final statusText = _getStatusText(spot);
              final statusIcon = _getStatusIcon(spot);
              final isClickable = _isClickable(spot);
              // Get remaining time for reserved spots
              Duration? remainingTime;
              if (spot.isReserved) {
                remainingTime = _getRemainingTime(index + 1);
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: 160.h,
                  width: MediaQuery.of(context).size.width / 2,
                  child: InkWell(
                    onTap: isClickable
                        ? () => _handleNavigation(context, spot, index)
                        : null,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Card(
                      elevation: isClickable ? 8 : 4,
                      shadowColor: statusColor.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: statusColor,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          image: DecorationImage(
                            image: AssetImage('assets/image/car1.png'),
                            fit: BoxFit.cover,
                            opacity: 0.1,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              statusColor.withOpacity(0.1),
                              statusColor.withOpacity(0.05),
                              statusColor.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.9),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18.r),
                                  topRight: Radius.circular(18.r),
                                ),
                              ),
                              child: Text(
                                spot.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ClashDisplay',
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: statusColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        statusIcon,
                                        size: 32.sp,
                                        color: statusColor,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    // Show remaining time for reserved spots
                                    if (spot.isReserved &&
                                        remainingTime != null &&
                                        remainingTime != Duration.zero) ...[
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: remainingTime.inMinutes <= 5
                                              ? Colors.red.withOpacity(0.1)
                                              : statusColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          '${remainingTime.inMinutes}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: TextStyle(
                                            color: remainingTime.inMinutes <= 5
                                                ? Colors.red
                                                : statusColor,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (!isClickable) ...[
                                      SizedBox(height: 4.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: statusColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          'Not Available',
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_parking_outlined,
                size: 60.sp,
                color: AppColors.fourthColor,
              ),
              SizedBox(height: 16.h),
              Text(
                'No parking spots available',
                style: TextStyle(
                  color: AppColors.fourthColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
