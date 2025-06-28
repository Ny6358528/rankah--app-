import 'package:rankah/core/api/api_consumer.dart';
import 'package:rankah/core/api/api_url.dart';
import 'package:rankah/feature/home/data/pending_reservation_model.dart';

abstract class PendingReservationRepository {
  Future<List<PendingReservationModel>> getPendingReservations();
}

class PendingReservationRepositoryImpl implements PendingReservationRepository {
  final ApiConsumer apiConsumer;

  PendingReservationRepositoryImpl({required this.apiConsumer}) {
    print('PendingReservationRepositoryImpl initialized');
    print(
        'PendingReservationRepositoryImpl: API URL will be ${ApiUrl.pendingReservations}');
  }

  @override
  Future<List<PendingReservationModel>> getPendingReservations() async {
    try {
      print(
          'PendingReservationRepository: Making API call to ${ApiUrl.pendingReservations}');
      final response = await apiConsumer.get(ApiUrl.pendingReservations);
      print('PendingReservationRepository: API response received: $response');
      print(
          'PendingReservationRepository: Response type: ${response.runtimeType}');

      List<PendingReservationModel> reservations = [];

      if (response is List) {
        // If response is a list
        reservations = response
            .map((reservation) => PendingReservationModel.fromJson(reservation))
            .toList();
      } else if (response is Map<String, dynamic>) {
        // If response is a single object
        reservations = [PendingReservationModel.fromJson(response)];
      } else {
        print(
            'PendingReservationRepository: Unexpected response format: $response');
        throw Exception('Invalid response format');
      }

      print(
          'PendingReservationRepository: Successfully parsed ${reservations.length} pending reservations');
      for (int i = 0; i < reservations.length; i++) {
        print(
            'PendingReservationRepository: Reservation ${i + 1}: ID: ${reservations[i].id}, Car: ${reservations[i].carNumber}, Spot: ${reservations[i].parkingSpotId}');
      }
      if (reservations.isNotEmpty) {
        print(
            'Received pending reservation ids: ${reservations.map((r) => r.id).toList()}');
      }
      return reservations;
    } catch (e) {
      // إذا كان الخطأ 404، اعتبرها لا يوجد حجوزات معلقة
      if (e.toString().contains('404')) {
        print('No pending reservations found (404). Returning empty list.');
        return [];
      }
      print(
          'PendingReservationRepository: Error fetching pending reservations: $e');
      throw Exception('Failed to fetch pending reservations: $e');
    }
  }
}
