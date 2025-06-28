import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rankah/feature/home/data/pending_reservation_repository.dart';
import 'package:rankah/feature/home/data/pending_reservation_model.dart';
import 'pending_reservation_state.dart';

class PendingReservationCubit extends Cubit<PendingReservationState> {
  final PendingReservationRepository pendingReservationRepository;

  PendingReservationCubit({required this.pendingReservationRepository})
      : super(PendingReservationInitial()) {
    print('PendingReservationCubit initialized');
  }

  List<PendingReservationModel> pendingReservations = [];

  Future<void> getPendingReservations() async {
    print('PendingReservationCubit: Starting to fetch pending reservations');
    emit(PendingReservationLoading());

    try {
      print(
          'PendingReservationCubit: Calling repository.getPendingReservations()');
      pendingReservations =
          await pendingReservationRepository.getPendingReservations();
      print(
          'PendingReservationCubit: Successfully fetched ${pendingReservations.length} pending reservations');

      for (var reservation in pendingReservations) {
        print(
            'PendingReservationCubit: Reservation: ID: ${reservation.id}, Car: ${reservation.carNumber}, Spot: ${reservation.parkingSpotId}');
      }

      emit(PendingReservationSuccess(pendingReservations: pendingReservations));
      print('PendingReservationCubit: Emitted PendingReservationSuccess');
    } catch (e) {
      print('PendingReservationCubit: Error fetching pending reservations: $e');
      emit(PendingReservationError(message: e.toString()));
      print('PendingReservationCubit: Emitted PendingReservationError');
    }
  }

  Future<void> refreshPendingReservations() async {
    print('PendingReservationCubit: Refreshing pending reservations');
    await getPendingReservations();
  }

  // Helper method to get reservation by spot ID
  PendingReservationModel? getReservationBySpotId(int spotId) {
    try {
      return pendingReservations
          .firstWhere((reservation) => reservation.parkingSpotId == spotId);
    } catch (e) {
      return null;
    }
  }
}
