import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/data/repositories/pg_repository.dart';
import 'package:pgcity/data/repositories/user_repository.dart';
import 'package:pgcity/data/repositories/enrollment_repository.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PGCity Core Business Logic & State Tests', () {
    late SharedPreferences prefs;
    late PGRepository pgRepo;
    late UserRepository userRepo;
    late EnrollmentRepository enrollRepo;
    late AppState appState;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      pgRepo = PGRepository(prefs);
      userRepo = UserRepository(prefs);
      enrollRepo = EnrollmentRepository(prefs);
      appState = AppState(
        pgRepository: pgRepo,
        userRepository: userRepo,
        enrollmentRepository: enrollRepo,
      );
      // Wait for async init
      await Future.delayed(const Duration(milliseconds: 50));
    });

    test('Seed PGs are loaded correctly on initial launch', () async {
      final pgs = await pgRepo.getAllPGs();
      expect(pgs.isNotEmpty, true);
      expect(pgs.any((p) => p.name.contains('Sunrise Girls PG')), true);
      expect(pgs.any((p) => p.name.contains('Green Residency PG')), true);
    });

    test('Gender and Price filtering works properly', () {
      // Test Girls PG filter
      appState.setGenderFilter(GenderFilter.girls);
      var filtered = appState.filteredPGs;
      expect(filtered.every((p) => p.type == PGType.girls), true);

      // Test Boys PG filter
      appState.setGenderFilter(GenderFilter.boys);
      filtered = appState.filteredPGs;
      expect(filtered.every((p) => p.type == PGType.boys), true);

      // Test Price filter under 10k
      appState.setGenderFilter(GenderFilter.all);
      appState.setPriceFilter(PriceFilter.under10k);
      filtered = appState.filteredPGs;
      expect(filtered.every((p) => p.monthlyRent < 10000), true);

      // Test Price filter above 10k
      appState.setPriceFilter(PriceFilter.above10k);
      filtered = appState.filteredPGs;
      expect(filtered.every((p) => p.monthlyRent >= 10000), true);
    });

    test('Search filtering by name and locality', () {
      appState.setSearchQuery('Satellite');
      final searchResults = appState.filteredPGs;
      expect(searchResults.isNotEmpty, true);
      expect(
        searchResults.every(
          (p) =>
              p.name.toLowerCase().contains('satellite') ||
              p.locality.toLowerCase().contains('satellite'),
        ),
        true,
      );
    });

    test('Toggle Like persists liked state and adjusts like count', () async {
      final pgs = await pgRepo.getAllPGs();
      final testPG = pgs.first;
      final initialLikes = testPG.likesCount;

      expect(appState.isPGLiked(testPG.id), false);

      await appState.toggleLike(testPG.id);
      expect(appState.isPGLiked(testPG.id), true);

      final reloadedPG = (await pgRepo.getAllPGs()).firstWhere(
        (p) => p.id == testPG.id,
      );
      expect(reloadedPG.likesCount, initialLikes + 1);

      await appState.toggleLike(testPG.id);
      expect(appState.isPGLiked(testPG.id), false);
    });

    test('Contact unlock persists and increments unlock count', () async {
      final pgs = await pgRepo.getAllPGs();
      final testPG = pgs.first;
      final initialUnlocks = testPG.contactUnlocksCount;

      expect(appState.isPGUnlocked(testPG.id), false);

      await appState.unlockPGContact(testPG.id);
      expect(appState.isPGUnlocked(testPG.id), true);

      final reloadedPG = (await pgRepo.getAllPGs()).firstWhere(
        (p) => p.id == testPG.id,
      );
      expect(reloadedPG.contactUnlocksCount, initialUnlocks + 1);
    });

    test('Enrollment submission and admin status transition', () async {
      final pgs = await pgRepo.getAllPGs();
      final testPG = pgs.first;

      await appState.submitEnrollment(
        pg: testPG,
        applicantName: 'Test Applicant',
        applicantPhone: '+91 99999 88888',
        applicantEmail: 'test@applicant.com',
        applicantGender: 'Male',
        applicantAge: 22,
        occupation: 'Student',
        moveInDate: DateTime.now().add(const Duration(days: 10)),
        sharingType: '2 Sharing',
        message: 'Looking for prompt confirmation.',
      );

      expect(appState.enrollments.isNotEmpty, true);
      final submitted = appState.enrollments.first;
      expect(submitted.status, EnrollmentStatus.submitted);

      // Admin accepts lead
      await appState.adminUpdateEnrollmentStatus(
        submitted.id,
        EnrollmentStatus.accepted,
      );
      final updated = appState.enrollments.firstWhere(
        (e) => e.id == submitted.id,
      );
      expect(updated.status, EnrollmentStatus.accepted);
    });

    test('OTP validation succeeds with demo and generated codes', () {
      appState.requestOTP('+91 98765 43210');
      expect(appState.verifyOTP('482100'), true);
      expect(appState.verifyOTP('000000'), false);
    });

    test('Authentication: Mobile + OTP login and state updates', () async {
      await appState.loginWithPhoneOtp('9876543210', '482100');
      expect(appState.isLoggedIn, true);
      expect(appState.currentUser?.mobileNumber.contains('9876543210'), true);
      expect(appState.currentUser?.authProvider, AuthProvider.phoneOtp);
    });

    test('Authentication: Mobile + Password login', () async {
      await appState.loginWithPhonePassword('9123456780', 'secretpass');
      expect(appState.isLoggedIn, true);
      expect(appState.currentUser?.authProvider, AuthProvider.phonePassword);
    });

    test('Authentication: Email + Password login', () async {
      await appState.loginWithEmailPassword('resident@pgcity.in', 'securepass');
      expect(appState.isLoggedIn, true);
      expect(appState.currentUser?.email, 'resident@pgcity.in');
      expect(appState.currentUser?.authProvider, AuthProvider.emailPassword);
    });

    test('Authentication: Google Sign-In simulation', () async {
      await appState.loginWithGoogle(name: 'Google Student', email: 'student@gmail.com');
      expect(appState.isLoggedIn, true);
      expect(appState.currentUser?.fullName, 'Google Student');
      expect(appState.currentUser?.isGoogleUser, true);
      expect(appState.currentUser?.authProvider, AuthProvider.google);
    });

    test('Authentication: Apple Sign-In simulation and Apple account deletion', () async {
      await appState.loginWithApple(appleId: 'apple_sub_12345', email: 'apple.user@icloud.com');
      expect(appState.isLoggedIn, true);
      expect(appState.currentUser?.isAppleUser, true);
      expect(appState.currentUser?.authProvider, AuthProvider.apple);

      // Test Apple-Specific account deletion (Apple Guideline 5.1.1(v))
      await appState.deleteAppleAccount();
      expect(appState.isLoggedIn, false);
      expect(appState.currentUser, null);
    });

    test('Authentication: Logout resets session to guest state', () async {
      await appState.loginWithGoogle();
      expect(appState.isLoggedIn, true);

      await appState.logoutUser();
      expect(appState.isLoggedIn, false);
      expect(appState.currentUser, null);
    });
  });
}
