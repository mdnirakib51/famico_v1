import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../initializer.dart';
import '../constants/storage_keys.dart';
import 'local_storage.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  SharedPreferences? _prefs;

  // Private constructor
  LocalStorageService._();

  /// Get singleton instance
  static Future<LocalStorageService> getInstance() async {
    if (_instance == null) {
      _instance = LocalStorageService._();
      await _instance!._init();
    }
    return _instance!;
  }

  /// Initialize SharedPreferences
  Future<void> _init() async {
    log("Initializing SharedPreferences...");
    _prefs = await SharedPreferences.getInstance();
    log("SharedPreferences initialized successfully");
  }

  // ==================== Quick Access Getters ====================

  /// Get access token
  String? get accessToken => locator<LocalStorage>().getString(key: StorageKeys.accessToken);

  // ==================== Convenience Methods ====================

  /// Save user token
  Future<void> saveUserToken(String token) async {
    log("Saving user token...");
    return locator<LocalStorage>().setString(key: StorageKeys.accessToken, value: token);
  }

}