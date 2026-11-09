import 'package:flutter/foundation.dart';

/// Level log, diurutkan dari yang paling rendah.
enum LogLevel { debug, info, warning, error }

/// Logger terstruktur. Log hanya tampil pada mode debug ([kDebugMode])
/// dan data sensitif otomatis disamarkan.
class Logger {
  Logger._();

  /// Pola data sensitif yang disamarkan, mis. `api_key=abc`, `token: xyz`.
  static final RegExp _sensitive = RegExp(
    r'(api[_-]?key|token|password|passwd|secret|authorization|bearer)(\s*[:=]\s*|\s+)\S+',
    caseSensitive: false,
  );

  /// Level minimum yang ditampilkan.
  static LogLevel minLevel = LogLevel.debug;

  static void debug(String message) => _log(LogLevel.debug, message);
  static void info(String message) => _log(LogLevel.info, message);
  static void warning(String message) => _log(LogLevel.warning, message);

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  /// Menyamarkan data sensitif pada [text].
  static String redact(String text) =>
      text.replaceAllMapped(_sensitive, (m) => '${m.group(1)}=[REDACTED]');

  static void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return; // tidak ada log di mode release
    if (level.index < minLevel.index) return;

    final time = DateTime.now().toIso8601String();
    final tag = level.name.toUpperCase();
    final buffer = StringBuffer('[$time][$tag] ${redact(message)}');
    if (error != null) buffer.write(' | error: ${redact(error.toString())}');
    debugPrint(buffer.toString());
    if (stackTrace != null && level == LogLevel.error) {
      debugPrint(stackTrace.toString());
    }
  }
}