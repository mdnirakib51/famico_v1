import 'package:dio/dio.dart';
import 'package:famico_v1/src/global/utils/toast_service.dart';
import 'package:flutter/material.dart';
import '../../global/utils/print_test.dart';

/// API Response Checker
/// Checks API response and shows appropriate messages
class ApiChecker {
  ApiChecker._(); // Private constructor

  /// Check API response status code and show message
  static void checkApi(int statusCode, String message) {
    switch (statusCode) {
      case 200:
      case 201:
      // Success
        ToastService.success(message, icon: Icons.check_circle);
        break;

      case 400:
      // Bad Request
        showCustomSnackBar(message, icon: Icons.info);
        break;

      case 401:
      // Unauthorized
        showCustomSnackBar(message.isEmpty ? 'Unauthorized. Please login again.' : message, icon: Icons.lock_outline);
        // TODO: Navigate to login or refresh token
        // _handleUnauthorized();
        break;

      case 403:
      // Forbidden
        showCustomSnackBar(message.isEmpty ? 'Access forbidden.' : message, icon: Icons.block);
        break;

      case 404:
      // Not Found
        showCustomSnackBar(message.isEmpty ? 'Resource not found.' : message, icon: Icons.search_off);
        break;

      case 422:
      // Unprocessable Entity (Validation Error)
        showCustomSnackBar(message, icon: Icons.error_outline);
        break;

      case 500:
      case 502:
      case 503:
      // Server Error
        showCustomSnackBar(message.isEmpty ? 'Server error. Please try again later.' : message, icon: Icons.cloud_off);
        // TODO: Optional - Perform logout on server error
        // _handleServerError();
        break;

      default:
      // Other errors
        showCustomSnackBar(message.isEmpty ? 'An error occurred.' : message, icon: Icons.error);
    }
  }

  /// Check Dio Response object
  static void checkDioResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final message = response.data is Map
        ? (response.data['message'] ?? 'Success')
        : 'Success';

    checkApi(statusCode, message);
  }

  /// Handle unauthorized error
  /// Override this method to implement logout logic
  static void _handleUnauthorized() {
    // TODO: Implement logout or token refresh
    // Example:
    // Get.offAll(() => LoginScreen());
    // or
    // context.read<AuthBloc>().add(LogoutRequested());
  }

  /// Handle server error
  /// Override this method if you want to logout on server error
  static void _handleServerError() {
    // TODO: Optional - Implement logout on server error
    // _handleUnauthorized();
  }

  /// Get user-friendly message for status code
  static String getMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 200:
      case 201:
        return 'Success';
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Validation error';
      case 500:
        return 'Server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'An error occurred';
    }
  }

  /// Check if status code is success
  static bool isSuccess(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// Check if status code is client error
  static bool isClientError(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// Check if status code is server error
  static bool isServerError(int statusCode) {
    return statusCode >= 500;
  }
}

/// Legacy ApiChecker class for backward compatibility
@Deprecated('Use ApiChecker instead')
class ApiCheckerDec {
  static void checkApi(int statusCode, String message) {
    ApiChecker.checkApi(statusCode, message);
  }
}