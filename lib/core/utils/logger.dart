import 'package:flutter/foundation.dart';

class AppLogger {
  static void debug(String message, [Object? data]) {
    if (kDebugMode) {
      print('[DEBUG] $message ${data ?? ""}');
    }
  }

  static void info(String message, [Object? data]) {
    if (kDebugMode) {
      print('[INFO] $message ${data ?? ""}');
    }
  }

  static void warning(String message, [Object? data]) {
    if (kDebugMode) {
      print('[WARNING] $message ${data ?? ""}');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('[ERROR] $message');
      if (error != null) print(error);
      if (stackTrace != null) print(stackTrace);
    }
  }
}
