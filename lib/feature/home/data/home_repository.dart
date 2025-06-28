import 'package:rankah/core/api/api_consumer.dart';
import 'package:rankah/core/api/api_url.dart';
import 'package:rankah/feature/home/data/parking_spot_model.dart';

abstract class HomeRepository {
  Future<List<ParkingSpotModel>> getParkingSpots();
}

class HomeRepositoryImpl implements HomeRepository {
  final ApiConsumer apiConsumer;

  HomeRepositoryImpl({required this.apiConsumer}) {
    print('HomeRepositoryImpl initialized');
    ApiUrl.printUrls();
    print('HomeRepositoryImpl: API URL will be ${ApiUrl.parkingSpots}');
  }

  @override
  Future<List<ParkingSpotModel>> getParkingSpots() async {
    try {
      print('HomeRepository: Making API call to ${ApiUrl.parkingSpots}');
      final response = await apiConsumer.get(ApiUrl.parkingSpots);
      print('HomeRepository: API response received: $response');
      print('HomeRepository: Response type: ${response.runtimeType}');

      if (response is List) {
        final spots =
            response.map((spot) => ParkingSpotModel.fromJson(spot)).toList();
        print(
            'HomeRepository: Successfully parsed ${spots.length} parking spots');
        for (int i = 0; i < spots.length; i++) {
          print(
              'HomeRepository: Spot ${i + 1}: ${spots[i].name} - Status: ${spots[i].spotStatus}');
        }
        return spots;
      }

      print(
          'HomeRepository: Invalid response format, expected List but got ${response.runtimeType}');
      throw Exception(
          'Invalid response format: Expected a list of parking spots');
    } catch (e) {
      print('HomeRepository: Error occurred: $e');
      if (e.toString().contains('SocketException') ||
          e.toString().contains('NetworkException')) {
        throw Exception(
            'No internet connection. Please check your network and try again.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout. Please try again.');
      } else {
        throw Exception('Failed to fetch parking spots: ${e.toString()}');
      }
    }
  }
}
