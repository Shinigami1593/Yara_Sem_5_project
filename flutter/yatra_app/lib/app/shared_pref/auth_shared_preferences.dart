import 'package:shared_preferences/shared_preferences.dart';

class SimpleStorageService {
  static const _keyEmail = 'yatra_user_email';
  static const _keyToken = 'yatra_auth_token';
  static const _keyBiometricEnabled = 'yatra_biometric_enabled';

  static Future<void> saveCredentials(String email, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyToken, token);
  }

  static Future<String?> getStoredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyBiometricEnabled, enabled);
  }

  static Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyBiometricEnabled) ?? false;
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyBiometricEnabled);
  }
}
