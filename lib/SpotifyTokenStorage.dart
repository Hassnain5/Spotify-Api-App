import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpotifyTokenStorage {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveTokens({
    required String? accessToken,
    required String? refreshToken,
    required DateTime? expiryDate,
  }) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    await _storage.write(
        key: 'expiryDate', value: expiryDate?.toIso8601String());
  }

  static Future<Map<String, dynamic>> loadTokens() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final refreshToken = await _storage.read(key: 'refreshToken');
    final expiryStr = await _storage.read(key: 'expiryDate');
    DateTime? expiryDate;
    if (expiryStr != null) expiryDate = DateTime.tryParse(expiryStr);

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiryDate': expiryDate,
    };
  }

  static Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
