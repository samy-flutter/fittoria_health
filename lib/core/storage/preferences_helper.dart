import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final SharedPreferences _prefs;

  PreferencesHelper(this._prefs);

  static const String _keyThemeMode = 'theme_mode';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyPatientName = 'patient_name';
  static const String _keyPatientEmail = 'patient_email';

  Future<void> setThemeMode(String themeMode) async {
    await _prefs.setString(_keyThemeMode, themeMode);
  }

  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'light';
  }

  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    await _prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> savePatientDetails(String name, String email) async {
    await _prefs.setString(_keyPatientName, name);
    await _prefs.setString(_keyPatientEmail, email);
  }

  String? getPatientName() {
    return _prefs.getString(_keyPatientName);
  }

  String? getPatientEmail() {
    return _prefs.getString(_keyPatientEmail);
  }

  Future<void> clearAll() async {
    await _prefs.remove(_keyThemeMode);
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyPatientName);
    await _prefs.remove(_keyPatientEmail);
  }
}
