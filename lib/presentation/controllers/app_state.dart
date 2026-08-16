import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/localization/app_strings.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/data/models/notification_model.dart';
import 'package:pgcity/data/repositories/pg_repository.dart';
import 'package:pgcity/data/repositories/user_repository.dart';
import 'package:pgcity/data/repositories/enrollment_repository.dart';

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
    notifyListeners();
  }

  Future<void> loginWithPhonePassword(String phone, String password) async {
    _currentUser =
        await userRepository.loginWithPhonePassword(phone, password);
    notifyListeners();
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    _currentUser =
        await userRepository.loginWithEmailPassword(email, password);
    notifyListeners();
  }

  Future<void> loginWithGoogle({String? name, String? email}) async {
    _currentUser =
        await userRepository.loginWithGoogle(name: name, email: email);
    notifyListeners();
  }

  Future<void> loginWithApple({String? appleId, String? email}) async {
    _currentUser =
        await userRepository.loginWithApple(appleId: appleId, email: email);
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
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await userRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> deleteAppleAccount() async {
    await userRepository.deleteAppleAccount();
    _currentUser = null;
    await enrollmentRepository.clearAll();
    _enrollments = [];
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await userRepository.clearUser();
    _currentUser = null;
    await enrollmentRepository.clearAll();
    _enrollments = [];
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

  Future<void> resetAllData() async {
    await pgRepository.resetToSeedData();
    await _init();
  }
}
