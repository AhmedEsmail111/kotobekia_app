import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool?> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is double) return await sharedPreferences!.setDouble(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    return null;
  }

  static Future<bool?> deleteAllData() async {
    return await sharedPreferences!.clear();
  }

  static Future<bool?> removeData({required String key}) async {
    return await sharedPreferences!.remove(key);
  }
}