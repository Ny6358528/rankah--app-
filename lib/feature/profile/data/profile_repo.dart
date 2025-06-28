import 'package:rankah/core/api/api_consumer.dart';
import 'package:rankah/core/api/api_url.dart';

class ProfileRepository {
  final ApiConsumer api;

  ProfileRepository({required this.api});

  Future<void> updateProfileInfo({
    required String name,
    required String phone,
  }) async {
    await api.post(
      ApiUrl.updateProfileInfo,
      body: {
        "fullName": name,
        "phoneNumber": phone,
      },
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await api.post(
      ApiUrl.changePassword,
      body: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
      },
    );
  }
}
