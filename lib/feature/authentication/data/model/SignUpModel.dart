class SignUpModel {
  final String fullname;
  final String email;
  final String phoneNumber;
  final String password;

  SignUpModel({
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullname,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      };
}
