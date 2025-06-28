import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:rankah/core/network/dio_helper.dart';

import 'package:rankah/feature/reservation/logic/cubit/reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationInitial());

  final TextEditingController carPlateNumberController =
      TextEditingController();

  int? selectedSpotId;
  int? reservationId;
  String? carNumber;

  Future<void> reserveSpot(int parkingSpotId) async {
    emit(ReservationLoading());
    try {
      final carNumber = carPlateNumberController.text.trim();
      final response = await DioHelper.dio.post(
        '/api/Reservation',
        data: {
          'carNumber': carNumber,
          'parkingSpotId': parkingSpotId,
        },
      );

      reservationId = response.data['id'];
      selectedSpotId = parkingSpotId;
      this.carNumber = carNumber;

      emit(ReservationSuccess(response.data));
    } catch (e) {
      emit(ReservationError('Reservation failed'));
    }
  }

  Future<void> openGate(int spotId) async {
    emit(OpenGateLoading());
    try {
      final carNumber = this.carNumber ?? carPlateNumberController.text.trim();
      await DioHelper.dio.post(
        '/api/Reservation/open-gate',
        data: {
          'carNumber': carNumber,
          'parkingSpotId': spotId,
        },
      );
      emit(OpenGateSuccess());
    } catch (e) {
      emit(OpenGateError('Failed to open gate'));
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    emit(CancelReservationLoading());
    try {
      print('Cancel Reservation with id: $reservationId');
      await DioHelper.dio.post('/api/Reservation/Cancel/$reservationId');
      emit(CancelReservationSuccess());
    } catch (e) {
      emit(CancelReservationError('Failed to cancel reservation: $e'));
    }
  }

  void setReservationData(int spotId, int reservationId, String carNumber) {
    this.selectedSpotId = spotId;
    this.reservationId = reservationId;
    this.carNumber = carNumber;
    print(
        'setReservationData: spotId=$spotId, reservationId=$reservationId, carNumber=$carNumber');
  }
}
