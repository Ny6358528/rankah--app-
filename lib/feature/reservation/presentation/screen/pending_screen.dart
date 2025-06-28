import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/core/services/service_locator.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';
import 'package:rankah/feature/reservation/presentation/widgets/pending_screen_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingScreen extends StatefulWidget {
  final int parkingSpotId;

  const PendingScreen({
    super.key,
    required this.parkingSpotId,
  });

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
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
    final remainingTime = _getRemainingTime(widget.parkingSpotId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Spot ${widget.parkingSpotId}'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
      ),
      body: PendingScreenBody(timeLeft: remainingTime),
    );
  }
}
