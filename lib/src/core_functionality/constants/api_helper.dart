import '../network/http_client/request_handler.dart';
import '../storage/storage_controller.dart';

/// Base API Helper - Framework Independent
/// All repositories should extend this class
abstract class ApiHelper {
  late final RequestHandler requestHandler;
  late final LocalStorageService storage;

  ApiHelper({
    RequestHandler? requestHandler,
    LocalStorageService? storage,
  }) {
    this.requestHandler = requestHandler ?? _getRequestHandler();
    this.storage = storage ?? _getStorage();
  }

  /// Get RequestHandler instance
  /// Override this in tests to provide mock
  RequestHandler _getRequestHandler() {
    // This will be injected or created
    throw UnimplementedError(
      'RequestHandler must be provided or implemented in subclass',
    );
  }

  /// Get LocalStorageService instance
  /// Override this in tests to provide mock
  LocalStorageService _getStorage() {
    // This will be injected or created
    throw UnimplementedError(
      'LocalStorageService must be provided or implemented in subclass',
    );
  }
}

abstract class ApiHelperSingleton {
  static RequestHandler? _requestHandler;
  static LocalStorageService? _storage;

  /// Initialize global instances
  static Future<void> initialize() async {
    _storage = await LocalStorageService.getInstance();
    _requestHandler = await RequestHandler.create();
  }

  RequestHandler get requestHandler {
    if (_requestHandler == null) {
      throw StateError(
        'ApiHelperSingleton not initialized. Call ApiHelperSingleton.initialize() first.',
      );
    }
    return _requestHandler!;
  }

  LocalStorageService get storage {
    if (_storage == null) {
      throw StateError(
        'ApiHelperSingleton not initialized. Call ApiHelperSingleton.initialize() first.',
      );
    }
    return _storage!;
  }
}