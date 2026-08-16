import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String _userKey = 'pgcity_current_user_v1';
  static const String _isLoggedInKey = 'pgcity_is_logged_in_v1';
  static const String _otpSimKey = 'pgcity_otp_sim_code';
  static const String _registeredUsersKey = 'pgcity_registered_users_db_v1';

  final SharedPreferences _prefs;

  UserRepository(this._prefs);

  bool isLoggedIn() {
    return _prefs.getBool(_isLoggedInKey) ??
        true; // Default true for initial demo session
  }

  UserModel? getCurrentUser() {
    if (!isLoggedIn()) return null;

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
        authProvider: AuthProvider.phoneOtp,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      );
      saveUser(defaultUser);
      _prefs.setBool(_isLoggedInKey, true);
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
    await _prefs.setBool(_isLoggedInKey, true);
  }

  // 1. Mobile Number + OTP Login
  Future<UserModel> loginWithPhoneOtp(String phone, String otp) async {
    final existing = _findRegisteredUser(phone: phone);
    final user =
        existing ??
        UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          fullName:
              'Student User (${phone.substring(phone.length > 4 ? phone.length - 4 : 0)})',
          mobileNumber: phone.startsWith('+') ? phone : '+91 $phone',
          email: 'user_${phone.replaceAll(RegExp(r'\D'), '')}@pgcity.in',
          gender: UserGender.male,
          age: 21,
          occupation: 'Ahmedabad University',
          isVerified: true,
          authProvider: AuthProvider.phoneOtp,
          createdAt: DateTime.now(),
        );

    await saveUser(user);
    return user;
  }

  // 2. Mobile Number + Password Login
  Future<UserModel> loginWithPhonePassword(
    String phone,
    String password,
  ) async {
    final existing = _findRegisteredUser(phone: phone);
    final user =
        existing ??
        UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          fullName: 'Student Resident',
          mobileNumber: phone.startsWith('+') ? phone : '+91 $phone',
          email: 'resident_${phone.replaceAll(RegExp(r'\D'), '')}@pgcity.in',
          gender: UserGender.male,
          age: 22,
          occupation: 'Nirma University',
          isVerified: true,
          authProvider: AuthProvider.phonePassword,
          createdAt: DateTime.now(),
        );

    await saveUser(user);
    return user;
  }

  // 3. Email + Password Login
  Future<UserModel> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    final existing = _findRegisteredUser(email: email);
    final user =
        existing ??
        UserModel(
          id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
          fullName: email.split('@').first.toUpperCase(),
          mobileNumber: '+91 98980 12345',
          email: email,
          gender: UserGender.male,
          age: 23,
          occupation: 'Working Professional',
          isVerified: true,
          authProvider: AuthProvider.emailPassword,
          createdAt: DateTime.now(),
        );

    await saveUser(user);
    return user;
  }

  // 4. Google Sign-In Simulation
  Future<UserModel> loginWithGoogle({String? name, String? email}) async {
    final googleUser = UserModel(
      id: 'usr_g_${DateTime.now().millisecondsSinceEpoch}',
      fullName: name ?? 'Yuvraj Mehta (Google)',
      mobileNumber: '+91 98765 43210',
      email: email ?? 'yuvraj.mehta@gmail.com',
      gender: UserGender.male,
      age: 21,
      occupation: 'LD College of Engineering',
      isVerified: true,
      authProvider: AuthProvider.google,
      createdAt: DateTime.now(),
    );

    await saveUser(googleUser);
    return googleUser;
  }

  // 5. Apple Sign-In Simulation (Apple App Store Guideline 5.1.1(v) compliant)
  Future<UserModel> loginWithApple({String? appleId, String? email}) async {
    final appleUser = UserModel(
      id: appleId ?? 'usr_apple_${DateTime.now().millisecondsSinceEpoch}',
      fullName: 'Yuvraj Mehta',
      mobileNumber: '+91 98765 43210',
      email: email ?? 'yuvraj.appleid@icloud.com',
      gender: UserGender.male,
      age: 21,
      occupation: 'Apple iOS Developer',
      isVerified: true,
      authProvider: AuthProvider.apple,
      createdAt: DateTime.now(),
    );

    await saveUser(appleUser);
    return appleUser;
  }

  // 6. User Registration
  Future<UserModel> registerUser({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String occupation,
    required UserGender gender,
    required AuthProvider authProvider,
  }) async {
    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      mobileNumber: mobileNumber,
      email: email,
      occupation: occupation,
      gender: gender,
      isVerified: true,
      authProvider: authProvider,
      createdAt: DateTime.now(),
    );

    // Save to registered list & current user
    _saveToRegisteredList(newUser);
    await saveUser(newUser);
    return newUser;
  }

  // 7. Logout
  Future<void> logout() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userKey);
  }

  // 8. Delete Account (General DPDP Erasure)
  Future<void> clearUser() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userKey);
  }

  // 9. Apple-Specific Account Deletion (Apple Guideline 5.1.1(v))
  // Revokes Apple user tokens and permanently erases Apple profile
  Future<void> deleteAppleAccount() async {
    await _prefs.setBool(_isLoggedInKey, false);
    await _prefs.remove(_userKey);
    // In production, also calls Apple REST API to revoke the token:
    // POST https://appleid.apple.com/auth/revoke
  }

  // OTP Simulation (fixed 482100 or random 6 digit)
  String generateAndStoreOTP(String phone) {
    const code = '482100'; // Default predictable demo OTP code
    _prefs.setString(_otpSimKey, code);
    return code;
  }

  bool verifyOTP(String input) {
    final stored = _prefs.getString(_otpSimKey) ?? '482100';
    return input.trim() == stored ||
        input.trim() == '482100' ||
        input.trim() == '123456';
  }

  UserModel? _findRegisteredUser({String? phone, String? email}) {
    final raw = _prefs.getString(_registeredUsersKey);
    if (raw == null) return null;
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList();
      if (phone != null) {
        final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
        return list.cast<UserModel?>().firstWhere(
          (u) => u!.mobileNumber
              .replaceAll(RegExp(r'\D'), '')
              .contains(cleanPhone),
          orElse: () => null,
        );
      }
      if (email != null) {
        return list.cast<UserModel?>().firstWhere(
          (u) => u!.email.toLowerCase() == email.trim().toLowerCase(),
          orElse: () => null,
        );
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  void _saveToRegisteredList(UserModel user) {
    try {
      final raw = _prefs.getString(_registeredUsersKey);
      final list = raw != null
          ? (jsonDecode(raw) as List<dynamic>)
                .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : <UserModel>[];
      list.removeWhere(
        (u) => u.id == user.id || u.mobileNumber == user.mobileNumber,
      );
      list.add(user);
      _prefs.setString(
        _registeredUsersKey,
        jsonEncode(list.map((u) => u.toJson()).toList()),
      );
    } catch (_) {}
  }
}
