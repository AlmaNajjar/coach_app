import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Save data
  static Future<bool> setData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      return await prefs.setStringList(key, value);
    }
    return false;
  }

  // Get String
  static Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Get Branch ID
  static Future<int?> getBranchId() async {
    try {
      final directBranchId = await getInt('branch_id');
      if (directBranchId != null) return directBranchId;

      final userJson = await getData('user_data');
      if (userJson != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        if (userMap.containsKey('branch_id') && userMap['branch_id'] != null) {
          return (userMap['branch_id'] as num).toInt();
        }
      }
    } catch (_) {}
    return null;
  }

  // Get Member ID
  static Future<int?> getMemberId() async {
    try {
      final userJson = await getData('user_data');
      if (userJson != null) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        if (userMap.containsKey('member_id') && userMap['member_id'] != null) {
          return (userMap['member_id'] as num).toInt();
        }
        if (userMap.containsKey('id') && userMap['id'] != null) {
          return (userMap['id'] as num).toInt();
        }
      }
    } catch (_) {}
    return null;
  }

  // Get Boolean
  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Get Integer
  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  // Get Double
  static Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  // Get String List
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  // Remove specific key
  static Future<bool> clearData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  // Clear all data (preserves saved username and password-change flags)
  static Future<bool> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keysToPreserve = <String, dynamic>{};
    for (final key in prefs.getKeys()) {
      if (key.startsWith('changed_pwd_') ||
          key == 'Saved_username' ||
          key == 'push_notifications_enabled') {
        keysToPreserve[key] = prefs.get(key);
      }
    }

    final result = await prefs.clear();

    for (final entry in keysToPreserve.entries) {
      if (entry.value is bool) {
        await prefs.setBool(entry.key, entry.value as bool);
      } else if (entry.value is String) {
        await prefs.setString(entry.key, entry.value as String);
      }
    }

    return result;
  }
}
