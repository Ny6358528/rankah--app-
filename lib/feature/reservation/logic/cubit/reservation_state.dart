import 'package:flutter/material.dart';

@immutable
abstract class ReservationState {}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {
  final dynamic data;
  ReservationSuccess(this.data);
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
}

class OpenGateLoading extends ReservationState {}

class OpenGateSuccess extends ReservationState {}

class OpenGateError extends ReservationState {
  final String message;
  OpenGateError(this.message);
}

class CancelReservationLoading extends ReservationState {}

class CancelReservationSuccess extends ReservationState {}

class CancelReservationError extends ReservationState {
  final String message;
  CancelReservationError(this.message);
}
