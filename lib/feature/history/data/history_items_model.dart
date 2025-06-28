class ReservationModel {
  final int id;
  final String parkingNumber;
  final String carNumber;
  final String status;
  final String startTime;
  final String endTime;

  ReservationModel({
    required this.id,
    required this.parkingNumber,
    required this.carNumber,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      parkingNumber: json['parkingNumber'] ?? 'N/A',
      carNumber: json['carNumber'] ?? 'N/A',
      status: json['status'] ?? 'Unknown',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }
}
