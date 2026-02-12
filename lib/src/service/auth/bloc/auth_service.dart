
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/local/preferences/local_storage.dart';
import '../../../domain/local/preferences/local_storage_keys.dart';
import '../../../initializer.dart';

class AuthService {

  static Future<void> saveCredentials({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      if (rememberMe) {
        locator<LocalStorage>().setString(key: StorageKeys.email, value: email);
        locator<LocalStorage>().setString(key: StorageKeys.password, value: password);
      } else {
        locator<LocalStorage>().remove(key: StorageKeys.email);
        locator<LocalStorage>().remove(key: StorageKeys.password);
      }
      locator<LocalStorage>().setBool(key: StorageKeys.rememberMe, value: rememberMe);
    } catch (e) {
      log("Error saving credentials: $e");
    }
  }

  static Map<String, dynamic> loadSavedCredentials() {
    try {
      final bool savedRememberMe = locator<LocalStorage>().getBool(key: StorageKeys.rememberMe, isTrue: true);
      String email = "";
      String password = "";

      if (savedRememberMe) {
        email = locator<LocalStorage>().getString(key: StorageKeys.email) ?? "";
        password = locator<LocalStorage>().getString(key: StorageKeys.password) ?? "";
      }

      return {
        'email': email,
        'password': password,
        'remember_me': savedRememberMe,
      };
    } catch (e) {
      log("Error loading credentials: $e");
      return {
        'email': "",
        'password': "",
        'remember_me': false,
      };
    }
  }

  static Future<void> performLogout() async {
    try {
      final String? token = locator<LocalStorage>().getString(key: StorageKeys.accessToken);
      SharedPreferences preferences = await SharedPreferences.getInstance();

      // Save data that should persist after logout
      final Map<String, dynamic> persistentData = {
        'base_url': locator<LocalStorage>().getString(key: StorageKeys.baseUrl),
        'email': locator<LocalStorage>().getString(key: StorageKeys.email),
        'password': locator<LocalStorage>().getString(key: StorageKeys.password),
        'remember_me': locator<LocalStorage>().getBool(key: StorageKeys.rememberMe),
      };

      log("===/@ User Token before clearing: $token");
      log("===/@ Persistent data: $persistentData");

      // Clear all preferences
      await preferences.clear();
      await preferences.setBool('isFirstRun', false);

      // Restore persistent data
      await _restorePersistentData(persistentData);

      // Navigate to login screen
      // await Get.offAll(() => const LoginScreen());

    } catch (e) {
      log("Error during logout: $e");
    }
  }

  static Future<void> _restorePersistentData(Map<String, dynamic> data) async {
    if (data['base_url'] != null && data['base_url'].toString().isNotEmpty) {
      locator<LocalStorage>().setString(key: StorageKeys.baseUrl, value: data['base_url']);
    }

    if (data['remember_me'] == true) {
      if (data['email'] != null) {
        locator<LocalStorage>().setString(key: StorageKeys.email, value: data['email']);
      }
      if (data['password'] != null) {
        locator<LocalStorage>().setString(key: StorageKeys.password, value: data['password']);
      }
      locator<LocalStorage>().setBool(key: StorageKeys.rememberMe, value: true);
    }
  }

  static Future<void> clearCredentials() async {
    try {
      locator<LocalStorage>().remove(key: StorageKeys.email);
      locator<LocalStorage>().remove(key: StorageKeys.password);
      locator<LocalStorage>().setBool(key: StorageKeys.rememberMe, value: false);
    } catch (e) {
      log("Error clearing credentials: $e");
    }
  }
}
