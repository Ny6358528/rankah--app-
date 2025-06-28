import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:rankah/core/services/service_locator.dart';
import 'package:rankah/feature/history/logic/cubit/history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  final Dio dio = sl<Dio>(); 

  List<dynamic> reservations = [];

  Future<void> fetchAllReservations() async {
    await _fetchData('/api/Reservation/CanceledAndCompleted');
  }

  Future<void> fetchCanceledReservations() async {
    await _fetchData('/api/Reservation/Canceled');
  }

  Future<void> fetchCompletedReservations() async {
    await _fetchData('/api/Reservation/Completed');
  }

  Future<void> _fetchData(String endpoint) async {
    emit(HistoryLoading());

    try {
      final response = await dio.get(endpoint); 
      if (response.statusCode == 200) {
        reservations = response.data;
        emit(HistoryLoaded(reservations));
      } else {
        emit(HistoryError("Unexpected error: ${response.statusMessage}"));
      }
    } catch (e) {
      emit(HistoryError("Fetch failed: $e"));
    }
  }
}
