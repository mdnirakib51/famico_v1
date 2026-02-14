import 'package:flutter/material.dart';

/// Toast/Snackbar Service - Can be called from anywhere
class ToastService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  /// Show custom snackbar
  static void show(
      String message, {
        ToastType type = ToastType.info,
        IconData? icon,
        Duration? duration,
        SnackBarAction? action,
      }) {
    final config = _getConfig(type);

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            icon ?? config.icon,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: config.color,
      duration: duration ?? const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      action: action,
    );

    scaffoldMessengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Show success message
  static void success(String message, {IconData? icon}) {
    show(message, type: ToastType.success, icon: icon);
  }

  /// Show error message
  static void error(String message, {IconData? icon}) {
    show(message, type: ToastType.error, icon: icon);
  }

  /// Show info message
  static void info(String message, {IconData? icon}) {
    show(message, type: ToastType.info, icon: icon);
  }

  /// Show warning message
  static void warning(String message, {IconData? icon}) {
    show(message, type: ToastType.warning, icon: icon);
  }

  /// Get configuration based on type
  static _ToastConfig _getConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastConfig(
          icon: Icons.check_circle,
          color: Colors.green,
        );
      case ToastType.error:
        return _ToastConfig(
          icon: Icons.error,
          color: Colors.red,
        );
      case ToastType.warning:
        return _ToastConfig(
          icon: Icons.warning,
          color: Colors.orange,
        );
      case ToastType.info:
        return _ToastConfig(
          icon: Icons.info,
          color: Colors.blue,
        );
    }
  }
}

/// Toast types
enum ToastType {
  success,
  error,
  warning,
  info,
}

/// Toast configuration
class _ToastConfig {
  final IconData icon;
  final Color color;

  _ToastConfig({
    required this.icon,
    required this.color,
  });
}

/// Legacy support - for backward compatibility
void showCustomSnackBar(
    String message, {
      IconData? icon,
      bool isError = true,
      double? duration,
    }) {
  ToastService.show(
    message,
    type: isError ? ToastType.error : ToastType.success,
    icon: icon,
    duration: duration != null
        ? Duration(seconds: duration.toInt())
        : const Duration(seconds: 3),
  );
}