import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<String> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "yok";
  }

  static Future<int> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    return true;
  }

  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    return true;
  }

  static Future<bool> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
    return true;
  }

  static Future clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
