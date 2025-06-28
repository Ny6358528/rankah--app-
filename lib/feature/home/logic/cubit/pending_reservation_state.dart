import 'package:flutter/material.dart';
import 'package:rankah/feature/home/data/pending_reservation_model.dart';

@immutable
abstract class PendingReservationState {}

class PendingReservationInitial extends PendingReservationState {}

class PendingReservationLoading extends PendingReservationState {}

class PendingReservationSuccess extends PendingReservationState {
  final List<PendingReservationModel> pendingReservations;
  PendingReservationSuccess({required this.pendingReservations});
}

class PendingReservationError extends PendingReservationState {
  final String message;
  PendingReservationError({required this.message});
}
