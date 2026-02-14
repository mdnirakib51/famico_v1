import 'dart:developer';
import 'dart:math' show min;
import 'package:dio/dio.dart';

import '../network/api_check.dart';

/// Custom Exception for API Request Errors
class RequestException implements Exception {
  final String method;
  final String url;
  final int? statusCode;
  final String? message;
  final Object error;
  final Response? res;
  final StackTrace trace;
  final dynamic data;
  final String? errorMsg;

  RequestException({
    required this.method,
    required this.url,
    this.statusCode,
    this.message,
    required this.error,
    this.res,
    this.data,
    required this.trace,
    this.errorMsg,
  }) {
    _handleException();
  }

  /// Handle exception and show appropriate message
  void _handleException() {
    try {
      ApiChecker.checkApi(
        statusCode ?? 0,
        message ?? "Unknown error",
      );
    } catch (e) {
      // Handle any errors from ApiChecker
      log('Error in ApiChecker: $e');
    }

    _logException();
  }

  /// Log exception details
  void _logException() {
    final responsePreview = res?.data != null
        ? res!.data.toString().substring(
      0,
      min(100, res!.data.toString().length),
    )
        : 'No response data';

    log(
      """
==/@
    Method: $method
    Url: $url
    StatusCode: $statusCode
    Message: $message
    Params: ${data.toString()}
    Response: $responsePreview...
    ErrorMsg: "$errorMsg"
==/@
""",
      name: "#RequestException",
      time: DateTime.now(),
      error: error,
      stackTrace: trace,
    );
  }

  @override
  String toString() {
    return 'RequestException: $method $url - $statusCode: $message';
  }

  /// Check if error is network related
  bool get isNetworkError {
    return error is DioException &&
        (error as DioException).type == DioExceptionType.connectionTimeout ||
        (error as DioException).type == DioExceptionType.receiveTimeout ||
        (error as DioException).type == DioExceptionType.connectionError;
  }

  /// Check if error is unauthorized (401)
  bool get isUnauthorized => statusCode == 401;

  /// Check if error is forbidden (403)
  bool get isForbidden => statusCode == 403;

  /// Check if error is not found (404)
  bool get isNotFound => statusCode == 404;

  /// Check if error is server error (500)
  bool get isServerError => statusCode == 500;

  /// Get user-friendly error message
  String get userMessage {
    if (isNetworkError) {
      return 'Network connection error. Please check your internet.';
    }

    if (isUnauthorized) {
      return 'Session expired. Please login again.';
    }

    if (isForbidden) {
      return 'You do not have permission to perform this action.';
    }

    if (isNotFound) {
      return 'The requested resource was not found.';
    }

    if (isServerError) {
      return 'Server error. Please try again later.';
    }

    return message ?? errorMsg ?? 'An error occurred. Please try again.';
  }
}