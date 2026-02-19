import 'dart:developer';
import 'dart:math' show min;
import 'package:dio/dio.dart';
import '../network/api_check.dart';

class RequestException implements Exception {
  final String method;
  final String url;
  final int? statusCode;
  final String? message;
  final String? errorDetail;
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
    this.errorDetail,
    required this.error,
    this.res,
    this.data,
    required this.trace,
    this.errorMsg,
  }) {
    _handleException();
  }

  void _handleException() {
    try {
      // ✅ Pass both message and errorDetail
      ApiChecker.checkApi(statusCode ?? 0, message ?? "Unknown error", errorDetail: errorDetail);
    } catch (e) {
      log('Error in ApiChecker: $e');
    }
    _logException();
  }

  void _logException() {
    final responsePreview = res?.data != null
        ? res!.data.toString().substring(0, min(100, res!.data.toString().length))
        : 'No response data';

    log(
      """
==/@
    Method: $method
    Url: $url
    StatusCode: $statusCode
    Message: $message
    ErrorDetail: $errorDetail
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
  String toString() => 'RequestException: $method $url - $statusCode: $message';

  bool get isNetworkError =>
      error is DioException &&
          ((error as DioException).type == DioExceptionType.connectionTimeout ||
          (error as DioException).type == DioExceptionType.receiveTimeout ||
          (error as DioException).type == DioExceptionType.connectionError);

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden    => statusCode == 403;
  bool get isNotFound     => statusCode == 404;
  bool get isServerError  => statusCode == 500;

  String get userMessage {
    if (isNetworkError)  return 'Network connection error. Please check your internet.';
    if (isUnauthorized)  return 'Session expired. Please login again.';
    if (isForbidden)     return 'You do not have permission to perform this action.';
    if (isNotFound)      return errorDetail ?? message ?? 'The requested resource was not found.';
    if (isServerError)   return 'Server error. Please try again later.';
    return errorDetail ?? message ?? errorMsg ?? 'An error occurred. Please try again.';
  }
}