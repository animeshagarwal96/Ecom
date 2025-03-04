import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences (Call this in main.dart before using it)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save String
  static Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get String
  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  // Save Integer
  static Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Get Integer
  static int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  // Save Boolean
  static Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get Boolean
  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Save Double
  static Future<void> saveDouble(String key, double value) async {
    await _preferences?.setDouble(key, value);
  }

  // Get Double
  static double? getDouble(String key) {
    return _preferences?.getDouble(key);
  }

  // Save List<String>
  static Future<void> saveStringList(String key, List<String> value) async {
    await _preferences?.setStringList(key, value);
  }

  // Get List<String>
  static List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  // Remove Key
  static Future<void> removeKey(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all preferences
  static Future<void> clearPreferences() async {
    await _preferences?.clear();
  }
}
