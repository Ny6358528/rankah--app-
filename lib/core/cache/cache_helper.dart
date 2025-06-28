import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  late SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  /// Initialize shared and secure storage
  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // -------------------- Shared Preferences --------------------

  dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  String? getString({required String key}) {
    return _sharedPreferences.getString(key);
  }

  Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) {
      return await _sharedPreferences.setBool(key, value);
    } else if (value is String) {
      return await _sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await _sharedPreferences.setInt(key, value);
    } else if (value is double) {
      return await _sharedPreferences.setDouble(key, value);
    } else {
      throw Exception("Unsupported value type");
    }
  }

  Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  Future<bool> containsKey({required String key}) async {
    return _sharedPreferences.containsKey(key);
  }

  Future<void> clearAllData() async {
    await _sharedPreferences.clear();
  }

  // -------------------- Secure Storage --------------------

  Future<void> saveSecureData({
    required String key,
    required String value,
  }) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecureData({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> removeSecureData({required String key}) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }
}
