class PendingReservationModel {
  final int id;
  final String carNumber;
  final String startTimeOfReservation;
  final int status;
  final int parkingSpotId;

  PendingReservationModel({
    required this.id,
    required this.carNumber,
    required this.startTimeOfReservation,
    required this.status,
    required this.parkingSpotId,
  });

  factory PendingReservationModel.fromJson(Map<String, dynamic> json) {
    return PendingReservationModel(
      id: json['id'] ?? 0,
      carNumber: json['carNumber'] ?? '',
      startTimeOfReservation: json['startTimeOfReservation'] ?? '',
      status: json['status'] ?? 0,
      parkingSpotId: json['parkingSpotId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carNumber': carNumber,
      'startTimeOfReservation': startTimeOfReservation,
      'status': status,
      'parkingSpotId': parkingSpotId,
    };
  }
}
