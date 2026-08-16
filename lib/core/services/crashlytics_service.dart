import 'package:flutter/foundation.dart';

class CrashlyticsReport {
  final DateTime timestamp;
  final String error;
  final String? reason;
  final String? stackTrace;
  final bool isFatal;
  final Map<String, dynamic> customKeys;
  final String? userId;

  CrashlyticsReport({
    required this.timestamp,
    required this.error,
    this.reason,
    this.stackTrace,
    required this.isFatal,
    required this.customKeys,
    this.userId,
  });
}

/// Firebase Crashlytics Service for PGCity.
/// Handles Flutter UI error interception, PlatformDispatcher error interception,
/// breadcrumbs logging, user tracking, and custom diagnostic keys.
class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  static CrashlyticsService get instance => _instance;

  CrashlyticsService._internal();

  bool _collectionEnabled = true;
  bool get isCrashlyticsCollectionEnabled => _collectionEnabled;

  String? _currentUserId;
  String? get currentUserId => _currentUserId;

  final Map<String, dynamic> _customKeys = {
    'app_name': 'PGCity Ahmedabad',
    'app_version': '1.0.0',
    'build_number': '100',
    'platform': defaultTargetPlatform.name,
  };
  Map<String, dynamic> get customKeys => Map.unmodifiable(_customKeys);

  final List<String> _breadcrumbs = [];
  List<String> get breadcrumbs => List.unmodifiable(_breadcrumbs);

  final List<CrashlyticsReport> _recordedReports = [];
  List<CrashlyticsReport> get recordedReports => List.unmodifiable(_recordedReports);

  /// Initializes error interception for Flutter UI & Dart async errors.
  void initialize() {
    // 1. Pass all uncaught errors from the Flutter framework to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) {
      recordFlutterError(details, fatal: false);
    };

    // 2. Pass all uncaught asynchronous Dart errors that aren't handled by Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      recordError(error, stack, reason: 'PlatformDispatcher unhandled async exception', fatal: true);
      return true;
    };

    log('Firebase Crashlytics Initialized for PGCity');
  }

  /// Toggle Crashlytics collection (e.g., user opt-out under DPDP Act 2023)
  void setCrashlyticsCollectionEnabled(bool enabled) {
    _collectionEnabled = enabled;
    log('Crashlytics data collection set to: $enabled');
  }

  /// Associate crashes and reports with a specific User ID (e.g. "usr_yuvraj_01")
  void setUserId(String userId) {
    _currentUserId = userId;
    setCustomKey('user_id', userId);
    log('Crashlytics User ID set: $userId');
  }

  /// Add custom key-value pairs to annotate crash reports
  void setCustomKey(String key, dynamic value) {
    _customKeys[key] = value;
  }

  /// Log a breadcrumb message to appear on the Crashlytics timeline
  void log(String message) {
    if (!_collectionEnabled) return;
    final timestamped = '[${DateTime.now().toIso8601String()}] $message';
    _breadcrumbs.add(timestamped);
    if (_breadcrumbs.length > 200) {
      _breadcrumbs.removeAt(0);
    }
  }

  /// Record a non-fatal or fatal error with stack trace and custom keys
  void recordError(
    dynamic error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
    Map<String, dynamic>? customKeys,
  }) {
    if (!_collectionEnabled) return;

    final mergedKeys = Map<String, dynamic>.from(_customKeys);
    if (customKeys != null) {
      mergedKeys.addAll(customKeys);
    }

    final report = CrashlyticsReport(
      timestamp: DateTime.now(),
      error: error.toString(),
      reason: reason,
      stackTrace: stack?.toString(),
      isFatal: fatal,
      customKeys: mergedKeys,
      userId: _currentUserId,
    );

    _recordedReports.add(report);
    if (_recordedReports.length > 100) {
      _recordedReports.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint(
        '🔥 [Firebase Crashlytics ${fatal ? "FATAL" : "NON-FATAL"}] $error\nReason: $reason\nUser: $_currentUserId',
      );
    }
  }

  /// Record FlutterErrorDetails from Flutter framework
  void recordFlutterError(FlutterErrorDetails details, {bool fatal = false}) {
    recordError(
      details.exception,
      details.stack,
      reason: details.context?.toDescription() ?? 'Flutter Framework Error',
      fatal: fatal,
      customKeys: {
        'library': details.library ?? 'unknown',
      },
    );
  }

  /// Trigger a test non-fatal exception to verify crashlytics pipeline
  void simulateNonFatalError() {
    try {
      throw Exception('Simulated PGCity Non-Fatal Exception (Test Diagnostic)');
    } catch (e, stack) {
      recordError(
        e,
        stack,
        reason: 'Manual User Diagnostic Test from Admin / Dev Portal',
        fatal: false,
      );
    }
  }

  /// Clear in-memory crash reports
  void clearReports() {
    _recordedReports.clear();
    _breadcrumbs.clear();
  }
}
