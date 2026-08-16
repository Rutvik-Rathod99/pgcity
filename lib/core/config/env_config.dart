import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static final Map<String, String> _env = {};

  static const String defaultGroqModel = 'llama-3.3-70b-versatile';
  static const String defaultGroqBaseUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  /// Initializes and parses the .env file from assets or local disk
  static Future<void> initialize() async {
    String? content;

    // 1. Try reading from rootBundle asset
    try {
      content = await rootBundle.loadString('.env');
    } catch (_) {
      // 2. Try reading from local file system (useful in tests & dev)
      try {
        final file = File('.env');
        if (await file.exists()) {
          content = await file.readAsString();
        }
      } catch (e) {
        if (kDebugMode) {
          print('EnvConfig: Could not read .env file: $e');
        }
      }
    }

    if (content != null && content.isNotEmpty) {
      _parseEnvContent(content);
    }
  }

  static void _parseEnvContent(String content) {
    final lines = content.split('\n');
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      final eqIdx = line.indexOf('=');
      if (eqIdx != -1) {
        final key = line.substring(0, eqIdx).trim();
        var value = line.substring(eqIdx + 1).trim();

        // Strip surrounding quotes if any
        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }

        if (key.isNotEmpty) {
          _env[key] = value;
        }
      }
    }
  }

  /// Get Groq API Key from .env or environment
  static String get groqApiKey {
    const fromEnv = String.fromEnvironment('GROQ_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _env['GROQ_API_KEY'] ?? '';
  }

  /// Get Groq Model from .env or fallback
  static String get groqModel {
    const fromEnv = String.fromEnvironment('GROQ_MODEL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _env['GROQ_MODEL'] ?? defaultGroqModel;
  }

  /// Get Groq Base URL from .env or fallback
  static String get groqBaseUrl {
    const fromEnv = String.fromEnvironment('GROQ_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return _env['GROQ_BASE_URL'] ?? defaultGroqBaseUrl;
  }
}
