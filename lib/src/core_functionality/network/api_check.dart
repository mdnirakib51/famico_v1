import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../global/utils/toast_service.dart';

class ApiChecker {
  ApiChecker._();

  /// ✅ Main method - message + errorDetail দুটোই দেখাবে
  /// [message]     = response['message']        → "Not Found"
  /// [errorDetail] = response['error']['error'] → "Invalid credentials"
  static void checkApi(
      int statusCode,
      String message, {
        String? errorDetail,
      }) {
    // Combine both messages
    final displayMessage = _buildMessage(message, errorDetail);

    switch (statusCode) {
      case 200:
      case 201:
        ToastService.success(displayMessage, icon: Icons.check_circle);
        break;

      case 400:
        ToastService.error(
          displayMessage.isEmpty ? 'Bad request' : displayMessage,
          icon: Icons.info,
        );
        break;

      case 401:
        ToastService.error(
          displayMessage.isEmpty ? 'Unauthorized. Please login again.' : displayMessage,
          icon: Icons.lock_outline,
        );
        break;

      case 403:
        ToastService.error(
          displayMessage.isEmpty ? 'Access forbidden.' : displayMessage,
          icon: Icons.block,
        );
        break;

      case 404:
        ToastService.error(
          displayMessage.isEmpty ? 'Resource not found.' : displayMessage,
          icon: Icons.search_off,
        );
        break;

      case 422:
        ToastService.error(
          displayMessage.isEmpty ? 'Validation error.' : displayMessage,
          icon: Icons.error_outline,
        );
        break;

      case 500:
      case 502:
      case 503:
        ToastService.error(
          displayMessage.isEmpty ? 'Server error. Please try again later.' : displayMessage,
          icon: Icons.cloud_off,
        );
        break;

      default:
        if (statusCode == 0) return; // No toast for uninitialized calls
        ToastService.error(
          displayMessage.isEmpty ? 'An error occurred.' : displayMessage,
          icon: Icons.error,
        );
    }
  }

  /// ✅ Build combined message
  /// "Not Found\nInvalid credentials"
  static String _buildMessage(String message, String? errorDetail) {
    final main   = message.trim();
    final detail = errorDetail?.trim() ?? '';

    if (main.isNotEmpty && detail.isNotEmpty) return '$main\n$detail';
    if (detail.isNotEmpty) return detail;
    return main;
  }

  // Helper methods
  static bool isSuccess(int statusCode)     => statusCode >= 200 && statusCode < 300;
  static bool isClientError(int statusCode) => statusCode >= 400 && statusCode < 500;
  static bool isServerError(int statusCode) => statusCode >= 500;
}

@Deprecated('Use ApiChecker instead')
class ApiCheckerDec {
  static void checkApi(int statusCode, String message) {
    ApiChecker.checkApi(statusCode, message);
  }
}