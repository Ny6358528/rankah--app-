class ApiUrl {
  static String baseUrl = "https://raknah.runasp.net";
  static String login = "$baseUrl/Auth/login";
  static String signUp = "$baseUrl/Auth/Register";
  static String parkingSpots = "$baseUrl/api/ParkingSpots";
  static String pendingReservations = "$baseUrl/api/Reservation/pending";
  static const String profileInfo = '/me';  
  static const String updateProfileInfo = '/me/info'; 
  static const String changePassword = '/change-password';

  static void printUrls() {
    print('ApiUrl: Base URL: $baseUrl');
    print('ApiUrl: Login URL: $login');
    print('ApiUrl: SignUp URL: $signUp');
    print('ApiUrl: Parking Spots URL: $parkingSpots');
    print('ApiUrl: Pending Reservations URL: $pendingReservations');
    print(
        'ApiUrl: Expected response format: [{"spotStatus":0,"name":"Spot-1"},{"spotStatus":0,"name":"Spot-2"},{"spotStatus":0,"name":"Spot-3"},{"spotStatus":0,"name":"Spot-4"}]');
  }
}
