import 'dart:developer';

import 'app_config.dart';

class ImageUrlHelper {
  /// Converts a relative image path from the server to a full URL.
  /// e.g. "/uploads/users/image/abc.jpg"
  ///   → "https://your-base-url.com/uploads/users/image/abc.jpg"
  static String resolve(String? path) {
    if (path == null || path.isEmpty) return '';

    // Already a full URL — return as-is
    if (path.startsWith('http://') || path.startsWith('https://')) {
      log("Img Path: $path");
      return path;
    }

    final base = AppConfig.base.url.replaceAll(RegExp(r'/+$'), '');
    final relative = path.startsWith('/') ? path : '/$path';
    return '$base$relative';
  }

  static bool isValid(String? path) => resolve(path).isNotEmpty;
}