
import 'dart:developer';

import '../../initializer.dart';
import '../local/preferences/local_storage.dart';
import '../local/preferences/local_storage_keys.dart';

enum UrlLink {
  isLive,
  isDev,
  isLocalServer,
}

enum AppConfig {
  base,
  baseImage,
  logInUrl,
  logOutUrl,
}

extension AppUrlExtention on AppConfig {
  static String _baseUrl = "";

  // Method to set predefined URLs
  static void setUrl(UrlLink urlLink) {
    switch (urlLink) {
      case UrlLink.isLive:
        _baseUrl = "";
        break;
      case UrlLink.isDev:
        _baseUrl = ""; // Default dev URL
        break;
      case UrlLink.isLocalServer:
        _baseUrl = "";
        break;
    }
  }

  // Method to set custom URL from user input
  static void setCustomUrl(String customUrl) {
    if (!customUrl.startsWith('http://') && !customUrl.startsWith('https://')) {
      customUrl = 'https://$customUrl';
    }
    if (customUrl.endsWith('/')) {
      customUrl = customUrl.substring(0, customUrl.length - 1);
    }

    _baseUrl = customUrl;
  }

  static void initializeUrl({UrlLink defaultUrlLink = UrlLink.isDev}) {
    try {
      final String? savedBaseUrl = locator<LocalStorage>().getString(key: StorageKeys.baseUrl);

      if (savedBaseUrl != null && savedBaseUrl.isNotEmpty) {
        setCustomUrl(savedBaseUrl);
        log("Using saved URL: $savedBaseUrl");
      } else {
        setUrl(defaultUrlLink);
        log("Using default URL for: $defaultUrlLink");
      }
    } catch (e) {
      setUrl(defaultUrlLink);
      log("Error loading saved URL, using default: $e");
    }
  }

  // Getter to retrieve current base URL
  static String get baseUrl => _baseUrl;

  String get url {
    switch (this) {
      case AppConfig.base:
        return _baseUrl;
      case AppConfig.baseImage:
        return "";
    /// ==========/@ Auth Api Url @/==========
      case AppConfig.logInUrl:
        return '/api/login';
      case AppConfig.logOutUrl:
        return '/api/logout';
    }
  }
}