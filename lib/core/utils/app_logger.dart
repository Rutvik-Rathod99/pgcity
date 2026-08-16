import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import '../services/crashlytics_service.dart';

enum AppLogLevel {
  debug('DEBUG', '🔍', 0),
  info('INFO', 'ℹ️', 1),
  warning('WARN', '⚠️', 2),
  error('ERROR', '🛑', 3),
  fatal('FATAL', '💥', 4);

  final String name;
  final String emoji;
  final int priority;
  const AppLogLevel(this.name, this.emoji, this.priority);
}

class LogEntry {
  final DateTime timestamp;
  final AppLogLevel level;
  final String message;
  final String tag;
  final dynamic error;
  final StackTrace? stackTrace;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    required this.tag,
    this.error,
    this.stackTrace,
  });

  String format({bool includeStack = true}) {
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}.${timestamp.millisecond.toString().padLeft(3, '0')}';
    final buffer = StringBuffer();
    buffer.write('[$timeStr] ${level.emoji} [${level.name}] [$tag] $message');
    if (error != null) {
      buffer.write('\n  Error: $error');
    }
    if (includeStack && stackTrace != null) {
      buffer.write('\n  StackTrace:\n$stackTrace');
    }
    return buffer.toString();
  }
}

/// Production-ready structured logger inspired by FoodEye architecture.
/// Features structured levels, in-memory circular buffer, live listeners,
/// and automatic dispatch to Firebase Crashlytics on errors.
class AppLogger {
  static const int _maxBufferSize = 500;
  static final List<LogEntry> _logs = [];
  static final List<void Function(LogEntry)> _listeners = [];
  static bool enableConsoleLogging = true;
  static AppLogLevel minLogLevel = AppLogLevel.debug;

  /// Add live log observer (e.g. for in-app log viewer screen)
  static void addListener(void Function(LogEntry) listener) {
    _listeners.add(listener);
  }

  static void removeListener(void Function(LogEntry) listener) {
    _listeners.remove(listener);
  }

  /// Debug level log
  static void d(String message, {String tag = 'APP', dynamic error, StackTrace? stackTrace}) {
    _log(AppLogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Info level log
  static void i(String message, {String tag = 'APP'}) {
    _log(AppLogLevel.info, message, tag: tag);
  }

  /// Warning level log
  static void w(String message, {String tag = 'APP', dynamic error, StackTrace? stackTrace}) {
    _log(AppLogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Error level log (Automatically dispatched to Firebase Crashlytics)
  static void e(String message, {String tag = 'APP', dynamic error, StackTrace? stackTrace}) {
    _log(AppLogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  /// Fatal level log (Dispatched as fatal to Firebase Crashlytics)
  static void f(String message, {String tag = 'APP', dynamic error, StackTrace? stackTrace}) {
    _log(AppLogLevel.fatal, message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    AppLogLevel level,
    String message, {
    required String tag,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (level.priority < minLogLevel.priority) return;

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );

    // 1. Maintain in-memory ring buffer
    if (_logs.length >= _maxBufferSize) {
      _logs.removeAt(0);
    }
    _logs.add(entry);

    // 2. Notify live UI listeners
    for (final listener in _listeners) {
      try {
        listener(entry);
      } catch (_) {}
    }

    // 3. Console output formatting
    if (enableConsoleLogging) {
      final formatted = entry.format(includeStack: kDebugMode);
      if (kDebugMode) {
        dev.log(
          formatted,
          name: tag,
          time: entry.timestamp,
          level: level.priority * 200 + 500,
          error: error,
          stackTrace: stackTrace,
        );
      } else {
        // ignore: avoid_print
        print(formatted);
      }
    }

    // 4. Firebase Crashlytics Integration
    // Record breadcrumb on info/debug/warn, and record non-fatal/fatal errors on error/fatal
    final crashlytics = CrashlyticsService.instance;
    crashlytics.log('[${level.name}] [$tag] $message');

    if (level == AppLogLevel.error) {
      crashlytics.recordError(
        error ?? Exception(message),
        stackTrace ?? StackTrace.current,
        reason: 'AppLogger.e: $message (Tag: $tag)',
        fatal: false,
      );
    } else if (level == AppLogLevel.fatal) {
      crashlytics.recordError(
        error ?? Exception(message),
        stackTrace ?? StackTrace.current,
        reason: 'AppLogger.f: $message (Tag: $tag)',
        fatal: true,
      );
    }
  }

  /// Get copy of all current recorded in-memory logs
  static List<LogEntry> get logs => List.unmodifiable(_logs);

  /// Clear all stored in-memory logs
  static void clear() {
    _logs.clear();
  }

  /// Export formatted logs as a single string for debugging / sharing
  static String exportLogsAsString() {
    final buffer = StringBuffer();
    buffer.writeln('=== PGCITY APPLICATION LOG EXPORT ===');
    buffer.writeln('Exported At: ${DateTime.now().toIso8601String()}');
    buffer.writeln('Total Entries: ${_logs.length}');
    buffer.writeln('======================================\n');
    for (final log in _logs) {
      buffer.writeln(log.format());
    }
    return buffer.toString();
  }
}
