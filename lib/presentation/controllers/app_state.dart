import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/localization/app_strings.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/data/models/notification_model.dart';
import 'package:pgcity/data/models/roommate_model.dart';
import 'package:pgcity/data/models/chat_message_model.dart';
import 'package:pgcity/data/models/rent_receipt_model.dart';
import 'package:pgcity/data/repositories/pg_repository.dart';
import 'package:pgcity/data/repositories/user_repository.dart';
import 'package:pgcity/data/repositories/enrollment_repository.dart';
import 'package:pgcity/core/utils/app_logger.dart';
import 'package:pgcity/core/services/crashlytics_service.dart';
import 'package:pgcity/core/services/biometric_auth_service.dart';

enum GenderFilter {
  all('All'),
  girls('Girls PG'),
  boys('Boys PG');

  final String label;
  const GenderFilter(this.label);
}

enum PriceFilter {
  all('All'),
  under10k('Under ₹10k'),
  above10k('Above ₹10k');

  final String label;
  const PriceFilter(this.label);
}

class AppState extends ChangeNotifier {
  final PGRepository pgRepository;
  final UserRepository userRepository;
  final EnrollmentRepository enrollmentRepository;
  final SharedPreferences? prefs;

  AppState({
    required this.pgRepository,
    required this.userRepository,
    required this.enrollmentRepository,
    this.prefs,
  }) {
    _init();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _currentCity = 'Ahmedabad, Gujarat';
  String get currentCity => _currentCity;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  GenderFilter _genderFilter = GenderFilter.all;
  GenderFilter get genderFilter => _genderFilter;

  PriceFilter _priceFilter = PriceFilter.all;
  PriceFilter get priceFilter => _priceFilter;

  List<PGModel> _allPGs = [];
  List<PGModel> get allPGs => _allPGs;

  PGModel? _selectedPG;
  PGModel? get selectedPG => _selectedPG;

  Set<String> _likedPGIds = {};
  Set<String> get likedPGIds => _likedPGIds;

  Set<String> _unlockedPGIds = {};
  Set<String> get unlockedPGIds => _unlockedPGIds;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<EnrollmentModel> _enrollments = [];
  List<EnrollmentModel> get enrollments => _enrollments;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;
  int get unreadNotificationsCount =>
      _notifications.where((n) => !n.isRead).length;

  bool _isAdminMode = false;
  bool get isAdminMode => _isAdminMode;

  bool _isMapView = true;
  bool get isMapView => _isMapView;

  // Appearance, Font, Language & Version States
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  AppFontFamily _appFont = AppFontFamily.inter;
  AppFontFamily get appFont => _appFont;

  AppLanguage _appLanguage = AppLanguage.english;
  AppLanguage get appLanguage => _appLanguage;

  int? _userAppRating;
  int? get userAppRating => _userAppRating;

  String get appVersion => '1.0.0';
  String get appBuildNumber => '100';
  String get appFullVersion => 'v1.0.0 (Build 100)';

  String tr(String key) => AppStrings.get(key, _appLanguage);

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    // Load appearance & locale preferences
    final savedTheme = prefs?.getString('pgcity_theme_mode');
    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (t) => t.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }

    final savedFont = prefs?.getString('pgcity_font_family');
    if (savedFont != null) {
      _appFont = AppFontFamily.values.firstWhere(
        (f) => f.name == savedFont,
        orElse: () => AppFontFamily.inter,
      );
      AppTypography.currentFont = _appFont;
    }

    final savedLang = prefs?.getString('pgcity_language');
    if (savedLang != null) {
      _appLanguage = AppLanguage.values.firstWhere(
        (l) => l.name == savedLang,
        orElse: () => AppLanguage.english,
      );
    }

    _userAppRating = prefs?.getInt('pgcity_user_rating');

    _allPGs = await pgRepository.getAllPGs();
    _likedPGIds = pgRepository.getLikedPGIds();
    _unlockedPGIds = pgRepository.getUnlockedPGIds();
    _currentUser = userRepository.getCurrentUser();
    _enrollments = enrollmentRepository.getAllEnrollments();

    if (_allPGs.isNotEmpty) {
      _selectedPG = _allPGs.first;
    }

    _notifications = [
      NotificationModel(
        id: 'notif_1',
        title: 'Welcome to PGCity!',
        message: 'Explore 360° virtual tours of verified PGs across Ahmedabad.',
        type: NotificationType.system,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NotificationModel(
        id: 'notif_2',
        title: 'Green Residency PG Accepted',
        message:
            'Your enrollment application has been accepted by the property management.',
        type: NotificationType.enrollmentAccepted,
        pgId: 'pg_green_residency',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Preference Modifiers
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await prefs?.setString('pgcity_theme_mode', mode.name);
    notifyListeners();
  }

  Future<void> setAppFont(AppFontFamily font) async {
    _appFont = font;
    AppTypography.currentFont = font;
    await prefs?.setString('pgcity_font_family', font.name);
    notifyListeners();
  }

  Future<void> setAppLanguage(AppLanguage lang) async {
    _appLanguage = lang;
    await prefs?.setString('pgcity_language', lang.name);
    notifyListeners();
  }

  Future<void> saveInAppRating({
    required int rating,
    required String feedback,
    required List<String> tags,
  }) async {
    _userAppRating = rating;
    await prefs?.setInt('pgcity_user_rating', rating);
    await prefs?.setString('pgcity_user_feedback', feedback);
    await prefs?.setStringList('pgcity_user_rating_tags', tags);
    notifyListeners();
  }

  // City Selector
  void setCity(String city) {
    _currentCity = city;
    notifyListeners();
  }

  // Search & Filters
  void setSearchQuery(String query) {
    _searchQuery = query;
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  void setGenderFilter(GenderFilter filter) {
    _genderFilter = filter;
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  void setPriceFilter(PriceFilter filter) {
    _priceFilter = filter;
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  void clearFilters() {
    _genderFilter = GenderFilter.all;
    _priceFilter = PriceFilter.all;
    _searchQuery = '';
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  void toggleViewMode() {
    _isMapView = !_isMapView;
    notifyListeners();
  }

  void toggleMapView() {
    _isMapView = !_isMapView;
    notifyListeners();
  }

  void selectPG(PGModel pg) {
    _selectedPG = pg;
    notifyListeners();
  }

  void clearSelectedPG() {
    _selectedPG = null;
    notifyListeners();
  }

  List<PGModel> get filteredPGs {
    return _allPGs.where((pg) {
      if (_genderFilter == GenderFilter.girls && pg.type != PGType.girls) {
        return false;
      }
      if (_genderFilter == GenderFilter.boys && pg.type != PGType.boys) {
        return false;
      }
      if (_priceFilter == PriceFilter.under10k && pg.monthlyRent >= 10000) {
        return false;
      }
      if (_priceFilter == PriceFilter.above10k && pg.monthlyRent < 10000) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = pg.name.toLowerCase().contains(query);
        final matchLocality = pg.locality.toLowerCase().contains(query);
        final matchSharing = pg.sharingType.toLowerCase().contains(query);
        final matchLandmark = pg.nearbyLandmarks.any(
          (l) => l.name.toLowerCase().contains(query),
        );
        if (!matchName && !matchLocality && !matchLandmark && !matchSharing) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void _updateSelectedAfterFilter() {
    final list = filteredPGs;
    if (_selectedPG == null || !list.any((p) => p.id == _selectedPG!.id)) {
      _selectedPG = list.isNotEmpty ? list.first : null;
    }
  }

  // Liked / Shortlisted
  bool isPGLiked(String pgId) => _likedPGIds.contains(pgId);

  Future<void> toggleLike(String pgId) async {
    await pgRepository.toggleLike(pgId);
    _likedPGIds = pgRepository.getLikedPGIds();
    _allPGs = await pgRepository.getAllPGs();
    if (_selectedPG?.id == pgId) {
      _selectedPG = _allPGs.firstWhere((p) => p.id == pgId);
    }
    notifyListeners();
  }

  List<PGModel> get likedPGs =>
      _allPGs.where((pg) => _likedPGIds.contains(pg.id)).toList();

  // Contact Unlock
  bool isPGUnlocked(String pgId) => _unlockedPGIds.contains(pgId);

  Future<void> unlockPGContact(String pgId) async {
    await pgRepository.unlockPGContact(pgId);
    _unlockedPGIds = pgRepository.getUnlockedPGIds();
    _allPGs = await pgRepository.getAllPGs();
    if (_selectedPG?.id == pgId) {
      _selectedPG = _allPGs.firstWhere((p) => p.id == pgId);
    }
    notifyListeners();
  }

  // User Profile
  Future<void> saveUserProfile(UserModel user) async {
    await userRepository.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }

  bool get isLoggedIn => userRepository.isLoggedIn() && _currentUser != null;

  Future<void> loginWithPhoneOtp(String phone, String otp) async {
    _currentUser = await userRepository.loginWithPhoneOtp(phone, otp);
    AppLogger.i(
      'User signed in with Phone OTP: ${_currentUser?.mobileNumber}',
      tag: 'AUTH',
    );
    if (_currentUser != null) {
      CrashlyticsService.instance.setUserId(_currentUser!.id);
    }
    notifyListeners();
  }

  Future<void> loginWithPhonePassword(String phone, String password) async {
    _currentUser = await userRepository.loginWithPhonePassword(phone, password);
    AppLogger.i(
      'User signed in with Phone & Password: ${_currentUser?.mobileNumber}',
      tag: 'AUTH',
    );
    if (_currentUser != null) {
      CrashlyticsService.instance.setUserId(_currentUser!.id);
    }
    notifyListeners();
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    _currentUser = await userRepository.loginWithEmailPassword(email, password);
    AppLogger.i(
      'User signed in with Email & Password: ${_currentUser?.email}',
      tag: 'AUTH',
    );
    if (_currentUser != null) {
      CrashlyticsService.instance.setUserId(_currentUser!.id);
    }
    notifyListeners();
  }

  Future<void> loginWithGoogle({String? name, String? email}) async {
    _currentUser = await userRepository.loginWithGoogle(
      name: name,
      email: email,
    );
    AppLogger.i(
      'User signed in with Google: ${_currentUser?.email}',
      tag: 'AUTH',
    );
    if (_currentUser != null) {
      CrashlyticsService.instance.setUserId(_currentUser!.id);
    }
    notifyListeners();
  }

  Future<void> loginWithApple({String? appleId, String? email}) async {
    _currentUser = await userRepository.loginWithApple(
      appleId: appleId,
      email: email,
    );
    AppLogger.i('User signed in with Apple ID (Guideline 5.1.1v)', tag: 'AUTH');
    if (_currentUser != null) {
      CrashlyticsService.instance.setUserId(_currentUser!.id);
    }
    notifyListeners();
  }

  Future<void> registerUser({
    required String fullName,
    required String mobileNumber,
    required String email,
    required String occupation,
    required UserGender gender,
    required AuthProvider authProvider,
  }) async {
    _currentUser = await userRepository.registerUser(
      fullName: fullName,
      mobileNumber: mobileNumber,
      email: email,
      occupation: occupation,
      gender: gender,
      authProvider: authProvider,
    );
    AppLogger.i(
      'New resident registered: ${_currentUser?.fullName}',
      tag: 'AUTH',
    );
    if (_currentUser != null) {
      CrashlyticsService.instance.setUserId(_currentUser!.id);
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    AppLogger.i('User logged out. Resetting to guest.', tag: 'AUTH');
    await userRepository.logout();
    _currentUser = null;
    CrashlyticsService.instance.setUserId('guest');
    notifyListeners();
  }

  Future<void> deleteAppleAccount() async {
    AppLogger.w(
      'Apple Account deleted & tokens revoked under Guideline 5.1.1(v)',
      tag: 'AUTH',
    );
    await userRepository.deleteAppleAccount();
    _currentUser = null;
    await enrollmentRepository.clearAll();
    _enrollments = [];
    CrashlyticsService.instance.setUserId('guest');
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    AppLogger.w('Account erased under DPDP Act 2023', tag: 'AUTH');
    await userRepository.clearUser();
    _currentUser = null;
    await enrollmentRepository.clearAll();
    _enrollments = [];
    CrashlyticsService.instance.setUserId('guest');
    notifyListeners();
  }

  // OTP Verification Simulation
  String requestOTP(String phoneNumber) {
    return userRepository.generateAndStoreOTP(phoneNumber);
  }

  bool verifyOTP(String input) {
    final valid = userRepository.verifyOTP(input);
    if (valid && _currentUser != null) {
      final verifiedUser = _currentUser!.copyWith(isVerified: true);
      saveUserProfile(verifiedUser);
    }
    return valid;
  }

  // Enrollment Submission
  Future<void> submitEnrollment({
    required PGModel pg,
    required String applicantName,
    required String applicantPhone,
    required String applicantEmail,
    required String applicantGender,
    required int applicantAge,
    required String occupation,
    required DateTime moveInDate,
    required String sharingType,
    String message = '',
  }) async {
    final newEnrollment = EnrollmentModel(
      id: 'enr_${DateTime.now().millisecondsSinceEpoch}',
      userId: _currentUser?.id ?? 'usr_guest',
      pgId: pg.id,
      pgName: pg.name,
      pgType: pg.type.label,
      pgRent: pg.monthlyRent,
      applicantName: applicantName,
      applicantPhone: applicantPhone,
      applicantEmail: applicantEmail,
      applicantGender: applicantGender,
      applicantAge: applicantAge,
      occupation: occupation,
      moveInDate: moveInDate,
      sharingType: sharingType,
      message: message,
      status: EnrollmentStatus.submitted,
      submittedAt: DateTime.now(),
    );

    await enrollmentRepository.addEnrollment(newEnrollment);
    _enrollments = enrollmentRepository.getAllEnrollments();

    // Increment PG enrollment count in repo
    final updatedPG = pg.copyWith(enrollmentsCount: pg.enrollmentsCount + 1);
    await pgRepository.addOrUpdatePG(updatedPG);
    _allPGs = await pgRepository.getAllPGs();

    // Add notification
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Enrollment Sent',
        message:
            'Your application for ${pg.name} has been submitted (Status: Submitted).',
        type: NotificationType.enrollmentSubmitted,
        pgId: pg.id,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // Notifications
  void markNotificationAsRead(String notifId) {
    final index = _notifications.indexWhere((n) => n.id == notifId);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }

  // Admin Management
  void toggleAdminMode() {
    _isAdminMode = !_isAdminMode;
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  Future<void> adminSavePG(PGModel pg) async {
    await pgRepository.addOrUpdatePG(pg);
    _allPGs = await pgRepository.getAllPGs();
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  Future<void> adminDeletePG(String id) async {
    await pgRepository.deletePG(id);
    _allPGs = await pgRepository.getAllPGs();
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  Future<void> adminUpdateEnrollmentStatus(
    String enrollmentId,
    EnrollmentStatus newStatus, {
    String? note,
  }) async {
    await enrollmentRepository.updateStatus(
      enrollmentId,
      newStatus,
      adminNote: note,
    );
    _enrollments = enrollmentRepository.getAllEnrollments();

    final item = _enrollments.firstWhere((e) => e.id == enrollmentId);
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Status Update: ${item.pgName}',
        message:
            'Your enrollment status has been updated to "${newStatus.label}".',
        type: newStatus == EnrollmentStatus.accepted
            ? NotificationType.enrollmentAccepted
            : NotificationType.system,
        pgId: item.pgId,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // -------------------------------------------------------------
  // 1. SIDE-BY-SIDE PG COMPARISON SUITE
  // -------------------------------------------------------------
  final Set<String> _comparePGIds = {};
  Set<String> get comparePGIds => _comparePGIds;
  List<PGModel> get comparedPGs =>
      _allPGs.where((p) => _comparePGIds.contains(p.id)).toList();

  bool isCompared(String pgId) => _comparePGIds.contains(pgId);

  bool toggleCompare(String pgId) {
    if (_comparePGIds.contains(pgId)) {
      _comparePGIds.remove(pgId);
      AppLogger.i(
        'Removed PG $pgId from comparison. Count=${_comparePGIds.length}',
        tag: 'COMPARE',
      );
      notifyListeners();
      return true;
    } else {
      if (_comparePGIds.length >= 3) {
        AppLogger.w(
          'Cannot add PG $pgId to comparison: Limit of 3 reached.',
          tag: 'COMPARE',
        );
        return false;
      }
      _comparePGIds.add(pgId);
      AppLogger.i(
        'Added PG $pgId to comparison. Count=${_comparePGIds.length}',
        tag: 'COMPARE',
      );
      notifyListeners();
      return true;
    }
  }

  void clearCompare() {
    _comparePGIds.clear();
    AppLogger.i('Cleared all compared PGs', tag: 'COMPARE');
    notifyListeners();
  }

  // -------------------------------------------------------------
  // 2. ROOMMATE MATCHER & COMPATIBILITY SUITE
  // -------------------------------------------------------------
  final List<RoommateModel> _roommates = [
    RoommateModel(
      id: 'rm_1',
      fullName: 'Aarav Patel',
      gender: 'Male',
      age: 21,
      collegeOrCompany: 'CEPT University (Architecture)',
      targetLocality: 'Navrangpura / University Road',
      budgetMax: 9500,
      foodHabit: FoodHabit.pureVeg,
      sleepHabit: SleepHabit.nightOwl,
      isSmokingAllowed: false,
      isAlcoholAllowed: false,
      bio:
          'Final year Architecture student. Quiet, focused on thesis, clean habits. Looking for a neat 2-sharing room.',
      contactNumber: '+91 98250 11223',
      isVerifiedStudent: true,
      avatarUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=400&q=80',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RoommateModel(
      id: 'rm_2',
      fullName: 'Diya Shah',
      gender: 'Female',
      age: 22,
      collegeOrCompany: 'Nirma University (MBA)',
      targetLocality: 'SG Highway / Gota',
      budgetMax: 11000,
      foodHabit: FoodHabit.jain,
      sleepHabit: SleepHabit.earlyBird,
      isSmokingAllowed: false,
      isAlcoholAllowed: false,
      bio:
          'MBA student at Nirma. Early riser, prepares Jain food, loves a peaceful environment and hygienic space.',
      contactNumber: '+91 97240 44556',
      isVerifiedStudent: true,
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    RoommateModel(
      id: 'rm_3',
      fullName: 'Rohan Mehta',
      gender: 'Male',
      age: 24,
      collegeOrCompany: 'TCS Gandhinagar (Software Engineer)',
      targetLocality: 'Infocity / Gandhinagar Kudasan',
      budgetMax: 12500,
      foodHabit: FoodHabit.vegEgg,
      sleepHabit: SleepHabit.flexible,
      isSmokingAllowed: false,
      isAlcoholAllowed: false,
      bio:
          'Software engineer at TCS. Work from home 3 days/week. Looking for a flatmate who values cleanliness and good Wi-Fi.',
      contactNumber: '+91 99099 77889',
      isVerifiedStudent: true,
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RoommateModel(
      id: 'rm_4',
      fullName: 'Pooja Joshi',
      gender: 'Female',
      age: 20,
      collegeOrCompany: 'HL College of Commerce',
      targetLocality: 'Commerce Six Roads / Navrangpura',
      budgetMax: 8000,
      foodHabit: FoodHabit.pureVeg,
      sleepHabit: SleepHabit.earlyBird,
      isSmokingAllowed: false,
      isAlcoholAllowed: false,
      bio:
          'B.Com student. Friendly, studious, non-smoker. Looking for a budget friendly PG roommate near college.',
      contactNumber: '+91 98980 33445',
      isVerifiedStudent: true,
      avatarUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];

  List<RoommateModel> get roommates => _roommates;

  void addRoommateProfile(RoommateModel profile) {
    _roommates.insert(0, profile);
    AppLogger.i(
      'Added new roommate profile for: ${profile.fullName}',
      tag: 'ROOMMATE',
    );
    notifyListeners();
  }

  // -------------------------------------------------------------
  // 3. IN-APP PROPERTY MANAGER CHAT INQUIRIES
  // -------------------------------------------------------------
  final Map<String, List<ChatMessageModel>> _chatHistories = {};

  List<ChatMessageModel> getChatForPG(String pgId, String pgName) {
    if (!_chatHistories.containsKey(pgId)) {
      _chatHistories[pgId] = [
        ChatMessageModel(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}_0',
          pgId: pgId,
          text:
              'Hello! I am the property manager for $pgName. How can I help with your room inquiry today?',
          sender: MessageSender.landlord,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
      ];
    }
    return _chatHistories[pgId]!;
  }

  void sendChatMessage(String pgId, String messageText, String pgName) {
    if (!_chatHistories.containsKey(pgId)) {
      getChatForPG(pgId, pgName);
    }

    final userMsg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      pgId: pgId,
      text: messageText,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    _chatHistories[pgId]!.add(userMsg);
    AppLogger.i('User sent message to PG $pgId: "$messageText"', tag: 'CHAT');
    notifyListeners();

    // Automated manager response simulation after 600ms
    Future.delayed(const Duration(milliseconds: 700), () {
      String response;
      final lower = messageText.toLowerCase();
      if (lower.contains('visit') ||
          lower.contains('schedule') ||
          lower.contains('time')) {
        response =
            'Sure! We would love to show you around. You can visit anytime between 10:00 AM and 7:00 PM. Would tomorrow at 4:00 PM work for you?';
      } else if (lower.contains('sharing') ||
          lower.contains('vacan') ||
          lower.contains('room')) {
        response =
            'Yes, we currently have 1 triple-sharing and 2 twin-sharing AC rooms available with immediate move-in.';
      } else if (lower.contains('food') ||
          lower.contains('jain') ||
          lower.contains('meal')) {
        response =
            'We serve 100% hygienic vegetarian meals (Breakfast, Lunch, Dinner). Jain food options are prepared separately on request.';
      } else if (lower.contains('bike') ||
          lower.contains('parking') ||
          lower.contains('car')) {
        response =
            'Dedicated covered two-wheeler parking with CCTV surveillance is included free of cost for all residents.';
      } else {
        response =
            'Thank you for your message! Our property supervisor will reach out shortly, or you can call us directly via the Call button.';
      }

      final managerMsg = ChatMessageModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}_reply',
        pgId: pgId,
        text: response,
        sender: MessageSender.landlord,
        timestamp: DateTime.now(),
      );

      _chatHistories[pgId]!.add(managerMsg);
      notifyListeners();
    });
  }

  // -------------------------------------------------------------
  // 4. DIGITAL MOVE-IN AGREEMENT & RENT RECEIPTS
  // -------------------------------------------------------------
  List<RentReceiptModel> get rentReceipts => [
    RentReceiptModel(
      invoiceId: 'INV-2026-0801',
      monthYear: 'August 2026',
      pgName: 'Sunrise Luxury PG for Girls',
      amount: 8500,
      electricityCharges: 620,
      maintenanceCharges: 350,
      transactionReference: 'UPI-AXIS-9928172648',
      paidDate: DateTime(2026, 8, 1),
      status: ReceiptPaymentStatus.paid,
    ),
    RentReceiptModel(
      invoiceId: 'INV-2026-0701',
      monthYear: 'July 2026',
      pgName: 'Sunrise Luxury PG for Girls',
      amount: 8500,
      electricityCharges: 780,
      maintenanceCharges: 350,
      transactionReference: 'UPI-HDFC-1102938475',
      paidDate: DateTime(2026, 7, 1),
      status: ReceiptPaymentStatus.paid,
    ),
    RentReceiptModel(
      invoiceId: 'INV-2026-0601',
      monthYear: 'June 2026',
      pgName: 'Sunrise Luxury PG for Girls',
      amount: 8500,
      electricityCharges: 540,
      maintenanceCharges: 350,
      transactionReference: 'UPI-ICICI-8849201948',
      paidDate: DateTime(2026, 6, 1),
      status: ReceiptPaymentStatus.paid,
    ),
  ];

  // -------------------------------------------------------------
  // 5. BIOMETRIC QUICK UNLOCK
  // -------------------------------------------------------------
  bool get isBiometricEnabled =>
      BiometricAuthService.instance.isBiometricEnabled;

  Future<void> setBiometricEnabled(bool enabled) async {
    await BiometricAuthService.instance.setBiometricEnabled(enabled);
    notifyListeners();
  }

  Future<void> resetAllData() async {
    await pgRepository.resetToSeedData();
    await _init();
  }
}
