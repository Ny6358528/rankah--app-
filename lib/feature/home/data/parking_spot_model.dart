import 'package:flutter/material.dart';

class ParkingSpotModel {
  final int spotStatus;
  final String name;

  ParkingSpotModel({
    required this.spotStatus,
    required this.name,
  });

  factory ParkingSpotModel.fromJson(Map<String, dynamic> json) {
    print('ParkingSpotModel: Parsing JSON: $json');
    final model = ParkingSpotModel(
      spotStatus: json['spotStatus'] ?? 0,
      name: json['name'] ?? '',
    );
    print(
        'ParkingSpotModel: Created model - Name: ${model.name}, Status: ${model.spotStatus}');
    return model;
  }

  Map<String, dynamic> toJson() {
    return {
      'spotStatus': spotStatus,
      'name': name,
    };
  }

  bool get isAvailable => spotStatus == 0;
  bool get isReserved => spotStatus == 1;
  bool get isOccupied => spotStatus == 2;
}

enum SpotStatus { available, reserved, occupied }

extension SpotStatusExtension on int {
  SpotStatus get toSpotStatus {
    switch (this) {
      case 0:
        return SpotStatus.available;
      case 1:
        return SpotStatus.reserved;
      case 2:
        return SpotStatus.occupied;
      default:
        return SpotStatus.available;
    }
  }
}

extension SpotStatusDisplay on SpotStatus {
  String get label {
    switch (this) {
      case SpotStatus.available:
        return 'Available';
      case SpotStatus.reserved:
        return 'Reserved';
      case SpotStatus.occupied:
        return 'Occupied';
    }
  }

  Color get color {
    switch (this) {
      case SpotStatus.available:
        return Colors.green;
      case SpotStatus.reserved:
        return Colors.amber;
      case SpotStatus.occupied:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case SpotStatus.available:
        return Icons.check_circle_outline;
      case SpotStatus.reserved:
        return Icons.schedule;
      case SpotStatus.occupied:
        return Icons.block;
    }
  }
}
