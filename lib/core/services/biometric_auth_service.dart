import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgcity/core/utils/app_logger.dart';

class BiometricAuthService {
  BiometricAuthService._();
  static final BiometricAuthService instance = BiometricAuthService._();

  static const String _prefBiometricKey = 'pgcity_biometric_enabled';
  bool _isBiometricEnabled = false;

  bool get isBiometricEnabled => _isBiometricEnabled;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isBiometricEnabled = prefs.getBool(_prefBiometricKey) ?? false;
    AppLogger.i('BiometricAuthService initialized: enabled=$_isBiometricEnabled', tag: 'SECURITY');
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    _isBiometricEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefBiometricKey, enabled);
    AppLogger.i('Biometric preference updated to: $enabled', tag: 'SECURITY');
  }

  Future<bool> authenticate({String reason = 'Authenticate to access PGCity'}) async {
    // Simulates biometric fingerprint / Face ID prompt
    AppLogger.i('Biometric authentication prompt triggered: $reason', tag: 'SECURITY');
    await Future.delayed(const Duration(milliseconds: 350));
    return true;
  }
}
