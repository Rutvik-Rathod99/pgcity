import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String _userKey = 'pgcity_current_user_v1';
  static const String _otpSimKey = 'pgcity_otp_sim_code';

  final SharedPreferences _prefs;

  UserRepository(this._prefs);

  UserModel? getCurrentUser() {
    final raw = _prefs.getString(_userKey);
    if (raw == null) {
      // Default demo initial user profile matching Screen 4/6 in PRD
      final defaultUser = UserModel(
        id: 'usr_yuvraj_01',
        fullName: 'Yuvraj Mehta',
        mobileNumber: '+91 98765 43210',
        email: 'yuvraj@email.com',
        gender: UserGender.male,
        age: 21,
        occupation: 'XYZ College of Engineering',
        isVerified: true,
        moveInDate: DateTime.now().add(const Duration(days: 30)),
        preferredSharing: '2 Sharing',
        currentCity: 'Ahmedabad',
        emergencyContact: '+91 98221 12233',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      );
      saveUser(defaultUser);
      return defaultUser;
    }
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<void> clearUser() async {
    await _prefs.remove(_userKey);
  }

  // OTP Simulation (fixed 482100 or random 6 digit)
  String generateAndStoreOTP(String phone) {
    const code = '482100'; // Default predictable demo OTP code
    _prefs.setString(_otpSimKey, code);
    return code;
  }

  bool verifyOTP(String input) {
    final stored = _prefs.getString(_otpSimKey) ?? '482100';
    return input.trim() == stored || input.trim() == '482100' || input.trim() == '123456';
  }
}
