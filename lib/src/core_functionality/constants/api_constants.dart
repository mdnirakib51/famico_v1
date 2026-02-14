/// API Configuration with Constants
class ApiConstants {
  ApiConstants._();

  // ==================== Timeouts ====================
  static const Duration timeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ==================== Headers ====================
  static const String contentTypeJson = 'application/json';
  static const String keepAlive = 'keep-alive';
  static const String contentTypeFormData = 'multipart/form-data';

  // ==================== Other Settings ====================
  static const int itemsPerPage = 20;
  static const int maxRetryAttempts = 3;
  static const String imageBaseUrl = '';
}