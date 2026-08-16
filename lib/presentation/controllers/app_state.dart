import 'package:flutter/material.dart';
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
  final PGRepository _pgRepository;
  final UserRepository _userRepository;
  final EnrollmentRepository _enrollmentRepository;

  AppState({
    required PGRepository pgRepository,
    required UserRepository userRepository,
    required EnrollmentRepository enrollmentRepository,
  })  : _pgRepository = pgRepository,
        _userRepository = userRepository,
        _enrollmentRepository = enrollmentRepository {
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
  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  bool _isAdminMode = false;
  bool get isAdminMode => _isAdminMode;

  bool _isMapView = true;
  bool get isMapView => _isMapView;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();

    _allPGs = await _pgRepository.getAllPGs();
    _likedPGIds = _pgRepository.getLikedPGIds();
    _unlockedPGIds = _pgRepository.getUnlockedPGIds();
    _currentUser = _userRepository.getCurrentUser();
    _enrollments = _enrollmentRepository.getAllEnrollments();

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
        message: 'Your enrollment application has been accepted by the property management.',
        type: NotificationType.enrollmentAccepted,
        pgId: 'pg_green_residency',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    _isLoading = false;
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
    _searchQuery = '';
    _genderFilter = GenderFilter.all;
    _priceFilter = PriceFilter.all;
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  void toggleViewMode() {
    _isMapView = !_isMapView;
    notifyListeners();
  }

  void selectPG(PGModel pg) {
    _selectedPG = pg;
    notifyListeners();
  }

  List<PGModel> get filteredPGs {
    return _allPGs.where((pg) {
      // Must be published in regular user mode
      if (!_isAdminMode && pg.verificationStatus != PGVerificationStatus.published) {
        return false;
      }

      // Search Query
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase().trim();
        final matchName = pg.name.toLowerCase().contains(q);
        final matchLocality = pg.locality.toLowerCase().contains(q);
        final matchAddress = pg.address.toLowerCase().contains(q);
        final matchLandmarks = pg.nearbyLandmarks.any((l) => l.name.toLowerCase().contains(q));
        if (!matchName && !matchLocality && !matchAddress && !matchLandmarks) {
          return false;
        }
      }

      // Gender Filter
      if (_genderFilter == GenderFilter.girls && pg.type != PGType.girls) {
        return false;
      }
      if (_genderFilter == GenderFilter.boys && pg.type != PGType.boys) {
        return false;
      }

      // Price Filter
      if (_priceFilter == PriceFilter.under10k && pg.monthlyRent >= 10000) {
        return false;
      }
      if (_priceFilter == PriceFilter.above10k && pg.monthlyRent < 10000) {
        return false;
      }

      return true;
    }).toList();
  }

  void _updateSelectedAfterFilter() {
    final list = filteredPGs;
    if (_selectedPG == null || !list.contains(_selectedPG)) {
      _selectedPG = list.isNotEmpty ? list.first : null;
    }
  }

  // Liked PGs
  bool isPGLiked(String pgId) => _likedPGIds.contains(pgId);

  Future<void> toggleLike(String pgId) async {
    await _pgRepository.toggleLike(pgId);
    _likedPGIds = _pgRepository.getLikedPGIds();
    _allPGs = await _pgRepository.getAllPGs();
    if (_selectedPG?.id == pgId) {
      _selectedPG = _allPGs.firstWhere((p) => p.id == pgId);
    }
    notifyListeners();
  }

  List<PGModel> get likedPGs {
    return _allPGs.where((pg) => _likedPGIds.contains(pg.id)).toList();
  }

  // Contact Unlock
  bool isPGUnlocked(String pgId) => _unlockedPGIds.contains(pgId);

  Future<void> unlockPGContact(String pgId) async {
    await _pgRepository.unlockPGContact(pgId);
    _unlockedPGIds = _pgRepository.getUnlockedPGIds();
    _allPGs = await _pgRepository.getAllPGs();
    if (_selectedPG?.id == pgId) {
      _selectedPG = _allPGs.firstWhere((p) => p.id == pgId);
    }
    notifyListeners();
  }

  // User Profile
  Future<void> saveUserProfile(UserModel user) async {
    await _userRepository.saveUser(user);
    _currentUser = user;
    notifyListeners();
  }

  Future<void> logoutUser() async {
    await _userRepository.clearUser();
    _currentUser = null;
    notifyListeners();
  }

  // OTP Verification Simulation
  String requestOTP(String phoneNumber) {
    return _userRepository.generateAndStoreOTP(phoneNumber);
  }

  bool verifyOTP(String input) {
    final valid = _userRepository.verifyOTP(input);
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

    await _enrollmentRepository.addEnrollment(newEnrollment);
    _enrollments = _enrollmentRepository.getAllEnrollments();

    // Increment PG enrollment count in repo
    final updatedPG = pg.copyWith(enrollmentsCount: pg.enrollmentsCount + 1);
    await _pgRepository.addOrUpdatePG(updatedPG);
    _allPGs = await _pgRepository.getAllPGs();

    // Add notification
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Enrollment Sent',
        message: 'Your application for ${pg.name} has been submitted (Status: Submitted).',
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
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  // Admin Management
  void toggleAdminMode() {
    _isAdminMode = !_isAdminMode;
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  Future<void> adminSavePG(PGModel pg) async {
    await _pgRepository.addOrUpdatePG(pg);
    _allPGs = await _pgRepository.getAllPGs();
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  Future<void> adminDeletePG(String id) async {
    await _pgRepository.deletePG(id);
    _allPGs = await _pgRepository.getAllPGs();
    _updateSelectedAfterFilter();
    notifyListeners();
  }

  Future<void> adminUpdateEnrollmentStatus(String enrollmentId, EnrollmentStatus newStatus, {String? note}) async {
    await _enrollmentRepository.updateStatus(enrollmentId, newStatus, adminNote: note);
    _enrollments = _enrollmentRepository.getAllEnrollments();

    final item = _enrollments.firstWhere((e) => e.id == enrollmentId);
    _notifications.insert(
      0,
      NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Status Update: ${item.pgName}',
        message: 'Your enrollment status has been updated to "${newStatus.label}".',
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
    await _pgRepository.resetToSeedData();
    await _init();
  }
}
