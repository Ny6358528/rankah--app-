import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rankah/core/services/service_locator.dart';
import 'package:rankah/core/utils/app_colors.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_state.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';
import 'package:rankah/feature/reservation/presentation/widgets/pending_screen_body.dart';
import 'package:rankah/feature/home/data/pending_reservation_model.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rankah/feature/reservation/presentation/screen/pending_screen.dart';

class PendingListScreen extends StatefulWidget {
  const PendingListScreen({super.key});

  @override
  State<PendingListScreen> createState() => _PendingListScreenState();
}

class _PendingListScreenState extends State<PendingListScreen> {
  Map<int, DateTime> reservationStartTimes = {};

  @override
  void initState() {
    super.initState();
    print('PendingListScreen: initState called');
    _loadReservationTimes();
    // Load pending reservations when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('PendingListScreen: calling getPendingReservations');
      context.read<PendingReservationCubit>().getPendingReservations();
    });
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
  Color _getStatusColor(PendingReservationModel reservation) {
    return Colors.amber; // All pending spots are amber
  }

  // Helper method to get status text
  String _getStatusText(PendingReservationModel reservation) {
    return 'Pending';
  }

  // Helper method to get status icon
  IconData _getStatusIcon(PendingReservationModel reservation) {
    return Icons.schedule;
  }

  // Helper method to check if spot is clickable
  bool _isClickable(PendingReservationModel reservation) {
    return true; // All pending spots are clickable
  }

  // Helper method to handle navigation
  void _handleNavigation(
      BuildContext context, PendingReservationModel reservation) {
    print('Navigate to PendingScreen with reservationId: ${reservation.id}');
    final spotId = reservation.parkingSpotId;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) {
            final cubit = sl<ReservationCubit>();
            cubit.setReservationData(
              reservation.parkingSpotId,
              reservation.id,
              reservation.carNumber,
            );
            return cubit;
          },
          child: PendingScreen(
            parkingSpotId: reservation.parkingSpotId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('PendingListScreen: build called');
    return RefreshIndicator(
      onRefresh: () async {
        print('PendingListScreen: onRefresh called');
        context.read<PendingReservationCubit>().getPendingReservations();
      },
      color: Colors.amber,
      backgroundColor: AppColors.secondaryColor,
      child: BlocBuilder<PendingReservationCubit, PendingReservationState>(
        builder: (context, state) {
          print('PendingListScreen: BlocBuilder state = ' + state.toString());
          if (state is PendingReservationLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Loading pending reservations...',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is PendingReservationError) {
            if (state.message.contains('404')) {
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
                      'No Pending Reservations',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You don\'t have any pending reservations.',
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
                      context
                          .read<PendingReservationCubit>()
                          .getPendingReservations();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: AppColors.secondaryColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is PendingReservationSuccess) {
            print(
                'PendingListScreen: PendingReservationSuccess with reservations = ' +
                    state.pendingReservations.toString());

            if (state.pendingReservations.isEmpty) {
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
                      'No Pending Reservations',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You don\'t have any pending reservations.',
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

            return ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: state.pendingReservations.length,
              itemBuilder: (context, index) {
                final reservation = state.pendingReservations[index];
                final spotId = reservation.parkingSpotId;
                final remainingTime = _getRemainingTime(spotId);

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.amber, width: 2),
                  ),
                  child: InkWell(
                    onTap: () => _handleNavigation(context, reservation),
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
                                  'Spot ${reservation.parkingSpotId}',
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
                                Icons.directions_car,
                                color: AppColors.fourthColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Car Number:',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.fourthColor,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                reservation.carNumber,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
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
                                          'Reservation for Spot ${reservation.parkingSpotId} has expired'),
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
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
