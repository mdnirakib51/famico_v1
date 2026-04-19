
import 'dart:developer';
import '../../initializer.dart';
import '../storage/local_storage.dart';
import 'storage_keys.dart';

enum ApiBaseUrl {
  isLive,
  isDev,
  isLocalServer,
}

enum AppConfig {
  base,
  baseImage,
  logInUrl,
  registrationUrl,
  forgetPasUrl,
  logOutUrl,

  userProfileUrl,
  updateProfileUrl,
  updatePassUrl,
  uploadDocUrl,

  addressUrl,
  familyNameUrl,
  relationShipUrl,
  relationUrl,
  familyMemberUrl,
  makeRelationshipUrl,
}

extension AppUrlExtension on AppConfig {
  static String _baseUrl = "";

  // Method to set predefined URLs
  static void setUrl(ApiBaseUrl urlLink) {
    switch (urlLink) {
      case ApiBaseUrl.isLive:
        _baseUrl = "";
        break;
      case ApiBaseUrl.isDev:
        _baseUrl = "http://famico.info";
        break;
      case ApiBaseUrl.isLocalServer:
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

  static void initializeUrl({ApiBaseUrl defaultUrlLink = ApiBaseUrl.isDev}) {
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
        return '/api/v1/user/auth/login';
      case AppConfig.registrationUrl:
        return '/api/v1/user/auth/register';
      case AppConfig.logOutUrl:
        return '/api/v1/logout';
      case AppConfig.forgetPasUrl:
        return '/api/v1/user/auth/forgot-password';

    /// ==========/@ User Api Url @/==========
      case AppConfig.userProfileUrl:
        return '/api/v1/user/profile';
      case AppConfig.updateProfileUrl:
        return '/api/v1/user/profile/update';
      case AppConfig.uploadDocUrl:
        return '/api/v1/user/upload-documents';
      case AppConfig.updatePassUrl:
        return '/api/v1/user/profile/update/password';

    /// ==========/@ Address Api Url @/==========
      case AppConfig.addressUrl:
        return '/api/v1/user/address';

      case AppConfig.familyNameUrl:
        return '/api/v1/user/family/name';
      case AppConfig.relationShipUrl:
        return '/api/v1/user/family/member/relationship-type';
      case AppConfig.relationUrl:
        return '/api/v1/user/family/member/relation';

      case AppConfig.familyMemberUrl:
        return '/api/v1/user/family/member';
      case AppConfig.makeRelationshipUrl:
        return '/api/v1/user/family/member/make-relationship';
    }
  }
}
