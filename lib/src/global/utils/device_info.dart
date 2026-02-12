
import 'dart:developer';
import 'dart:io' as io;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class GetDeviceInfo {
  static String? _deviceOS;
  static String get deviceOS => _deviceOS ?? "unknown";

  static String? _deviceID;
  static String get deviceID => _deviceID ?? "unknown";

  static String? _deviceName;
  static String get deviceName => _deviceName ?? "unknown";

  static String? _ipAddress;
  static String get ipAddress => _ipAddress ?? "unknown";

  static int? _deviceSDKVersion;
  static int get deviceSDKVersion => _deviceSDKVersion ?? 0;

  static bool? _isMobile;
  static bool get isMobile => _isMobile ?? false;

  static Future<void> getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

      // Get IP Address
      var connectivityResults = await Connectivity().checkConnectivity();
      // if (connectivityResults == ConnectivityResult.mobile || connectivityResults == ConnectivityResult.wifi) {
      //   _ipAddress = await _getIpAddress();
      // }
      // Check if any of the connectivity results are either mobile or wifi
      if (connectivityResults.contains(ConnectivityResult.mobile) || connectivityResults.contains(ConnectivityResult.wifi)) {
        _ipAddress = await _getIpAddress();
      }


      if (kIsWeb) {
        // Web specific device info
        WebBrowserInfo webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
        _deviceOS = "WEB";
        _deviceID = webBrowserInfo.vendor ?? "unknown";
        _deviceName = webBrowserInfo.userAgent ?? "unknown";
        _deviceSDKVersion = 0; // SDK version isn't applicable on web
        _isMobile = false; // Assuming web is not a mobile platform
      } else if (io.Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        _deviceOS = "ANDROID";
        _deviceID = androidDeviceInfo.id;
        _deviceName = androidDeviceInfo.model;
        _deviceSDKVersion = androidDeviceInfo.version.sdkInt;
        _isMobile = true;
      } else if (io.Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        _deviceOS = "iOS";
        _deviceID = iosDeviceInfo.identifierForVendor;
        _deviceName = iosDeviceInfo.name;
        _isMobile = true;
      } else {
        _deviceOS = "unknown";
        _deviceID = "unknown";
        _isMobile = false;
      }

      log(
          """
==/@ Device Information:
    Device OS: "$_deviceOS"
    Device ID: "$_deviceID"
    Device Name: "$_deviceName"
    IP Address: "$_ipAddress"
    Device SDK Version: "$_deviceSDKVersion"
    Mobile: "$_isMobile"
==/@
"""
      );
    } catch (e, s) {
      log("Device Error: ", error: e, stackTrace: s);
    }
  }

  static Future<String?> _getIpAddress() async {
    try {
      for (var interface in await io.NetworkInterface.list()) {
        for (var address in interface.addresses) {
          if (address.type == io.InternetAddressType.IPv4 && !address.isLoopback) {
            return address.address; // Return first found IPv4 address
          }
        }
      }
    } catch (e) {
      log('Failed to get IP address: $e');
    }
    return null;
  }
}
