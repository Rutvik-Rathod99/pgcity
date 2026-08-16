import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/localization/app_strings.dart';
import 'package:pgcity/core/services/crashlytics_service.dart';
import 'package:pgcity/core/utils/app_logger.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/data/models/roommate_model.dart';
import 'package:pgcity/data/models/chat_message_model.dart';
import 'package:pgcity/core/services/pg_share_service.dart';
import 'package:pgcity/core/services/groq_ai_service.dart';
import 'package:pgcity/core/config/env_config.dart';
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
      await EnvConfig.initialize();
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      pgRepo = PGRepository(prefs);
      userRepo = UserRepository(prefs);
      enrollRepo = EnrollmentRepository(prefs);
      appState = AppState(
        pgRepository: pgRepo,
        userRepository: userRepo,
        enrollmentRepository: enrollRepo,
        prefs: prefs,
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
      await appState.loginWithGoogle(
        name: 'Google Student',
        email: 'student@gmail.com',
      );
      expect(appState.isLoggedIn, true);
      expect(appState.currentUser?.fullName, 'Google Student');
      expect(appState.currentUser?.isGoogleUser, true);
      expect(appState.currentUser?.authProvider, AuthProvider.google);
    });

    test(
      'Authentication: Apple Sign-In simulation and Apple account deletion',
      () async {
        await appState.loginWithApple(
          appleId: 'apple_sub_12345',
          email: 'apple.user@icloud.com',
        );
        expect(appState.isLoggedIn, true);
        expect(appState.currentUser?.isAppleUser, true);
        expect(appState.currentUser?.authProvider, AuthProvider.apple);

        // Test Apple-Specific account deletion (Apple Guideline 5.1.1(v))
        await appState.deleteAppleAccount();
        expect(appState.isLoggedIn, false);
        expect(appState.currentUser, null);
      },
    );

    test('Authentication: Logout resets session to guest state', () async {
      await appState.loginWithGoogle();
      expect(appState.isLoggedIn, true);

      await appState.logoutUser();
      expect(appState.isLoggedIn, false);
      expect(appState.currentUser, null);
    });

    test('Theme Mode: Switch between System, Light, and Dark mode', () async {
      expect(appState.themeMode, ThemeMode.system);

      await appState.setThemeMode(ThemeMode.dark);
      expect(appState.themeMode, ThemeMode.dark);

      await appState.setThemeMode(ThemeMode.light);
      expect(appState.themeMode, ThemeMode.light);
    });

    test('Font Selection: Switch typography styles', () async {
      expect(appState.appFont, AppFontFamily.inter);

      await appState.setAppFont(AppFontFamily.ubuntu);
      expect(appState.appFont, AppFontFamily.ubuntu);
      expect(AppTypography.currentFont, AppFontFamily.ubuntu);

      await appState.setAppFont(AppFontFamily.sfPro);
      expect(appState.appFont, AppFontFamily.sfPro);
      expect(AppTypography.currentFont, AppFontFamily.sfPro);

      await appState.setAppFont(AppFontFamily.outfit);
      expect(appState.appFont, AppFontFamily.outfit);
      expect(AppTypography.currentFont, AppFontFamily.outfit);

      await appState.setAppFont(AppFontFamily.plusJakartaSans);
      expect(appState.appFont, AppFontFamily.plusJakartaSans);
    });

    test('Language Selection: English, Gujarati, Hindi localization', () async {
      expect(appState.appLanguage, AppLanguage.english);
      expect(appState.tr('nav_explore'), 'Explore');

      await appState.setAppLanguage(AppLanguage.gujarati);
      expect(appState.appLanguage, AppLanguage.gujarati);
      expect(appState.tr('nav_explore'), 'શોધો (Explore)');

      await appState.setAppLanguage(AppLanguage.hindi);
      expect(appState.appLanguage, AppLanguage.hindi);
      expect(appState.tr('nav_explore'), 'खोजें (Explore)');
    });

    test('In-App Rating: Save rating, tags, and feedback review', () async {
      expect(appState.userAppRating, null);

      await appState.saveInAppRating(
        rating: 5,
        feedback: 'Super clean PG photos and rapid landlord responses!',
        tags: ['📸 100% Real Photos', '🔒 Safe Neighborhood'],
      );

      expect(appState.userAppRating, 5);
      expect(prefs.getInt('pgcity_user_rating'), 5);
      expect(
        prefs.getString('pgcity_user_feedback'),
        'Super clean PG photos and rapid landlord responses!',
      );
    });

    test('App Version & Build Number Display', () {
      expect(appState.appVersion, '1.0.0');
      expect(appState.appBuildNumber, '100');
      expect(appState.appFullVersion, 'v1.0.0 (Build 100)');
    });

    test('AppLogger & Firebase Crashlytics logging pipeline', () {
      AppLogger.clear();
      expect(AppLogger.logs.isEmpty, true);

      AppLogger.d('Debug level test message', tag: 'TEST');
      AppLogger.i('Info level test message', tag: 'TEST');
      AppLogger.w('Warning level test message', tag: 'TEST');
      AppLogger.e(
        'Error level test message',
        tag: 'TEST',
        error: 'Sample Error',
      );

      expect(AppLogger.logs.length, 4);
      expect(AppLogger.logs.any((l) => l.level == AppLogLevel.error), true);

      final export = AppLogger.exportLogsAsString();
      expect(export.contains('=== PGCITY APPLICATION LOG EXPORT ==='), true);
      expect(export.contains('Sample Error'), true);

      // Crashlytics pipeline verification
      final crashlytics = CrashlyticsService.instance;
      crashlytics.clearReports();
      crashlytics.setUserId('usr_test_99');
      crashlytics.setCustomKey('test_key', 'test_value');
      crashlytics.log('Test Breadcrumb');
      crashlytics.simulateNonFatalError();

      expect(crashlytics.currentUserId, 'usr_test_99');
      expect(crashlytics.recordedReports.isNotEmpty, true);
      expect(
        crashlytics.breadcrumbs.any((b) => b.contains('Test Breadcrumb')),
        true,
      );
    });

    test(
      'PG Comparison Suite: Toggle compare, max 3 limit, and clear',
      () async {
        final pgs = await pgRepo.getAllPGs();
        expect(appState.comparePGIds.isEmpty, true);

        // Add 1st PG
        expect(appState.toggleCompare(pgs[0].id), true);
        expect(appState.isCompared(pgs[0].id), true);
        expect(appState.comparePGIds.length, 1);

        // Add 2nd and 3rd PG
        expect(appState.toggleCompare(pgs[1].id), true);
        expect(appState.toggleCompare(pgs[2].id), true);
        expect(appState.comparePGIds.length, 3);
        expect(appState.comparedPGs.length, 3);

        // Attempt 4th PG (should fail limit of 3)
        if (pgs.length > 3) {
          expect(appState.toggleCompare(pgs[3].id), false);
          expect(appState.comparePGIds.length, 3);
        }

        // Remove 1st PG
        expect(appState.toggleCompare(pgs[0].id), true);
        expect(appState.isCompared(pgs[0].id), false);
        expect(appState.comparePGIds.length, 2);

        // Clear compare
        appState.clearCompare();
        expect(appState.comparePGIds.isEmpty, true);
      },
    );

    test('Roommate Matcher Suite: Sample roommates and add profile', () {
      expect(appState.roommates.isNotEmpty, true);
      final initialCount = appState.roommates.length;

      final newProfile = RoommateModel(
        id: 'rm_test_1',
        fullName: 'Karan Shah',
        gender: 'Male',
        age: 23,
        collegeOrCompany: 'DAIICT Gandhinagar',
        targetLocality: 'Kudasan / Infocity',
        budgetMax: 12000,
        foodHabit: FoodHabit.pureVeg,
        sleepHabit: SleepHabit.nightOwl,
        bio: 'M.Tech student seeking neat roommate.',
        contactNumber: '+91 98000 11111',
        avatarUrl:
            'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
        postedAt: DateTime.now(),
      );

      appState.addRoommateProfile(newProfile);
      expect(appState.roommates.length, initialCount + 1);
      expect(appState.roommates.first.fullName, 'Karan Shah');
    });

    test(
      'In-App Landlord Chat Suite: Send message and receive auto-response',
      () async {
        final pgs = await pgRepo.getAllPGs();
        final testPG = pgs.first;

        final chat = appState.getChatForPG(testPG.id, testPG.name);
        expect(chat.isNotEmpty, true);
        expect(chat.first.sender, MessageSender.landlord);

        appState.sendChatMessage(
          testPG.id,
          'Can I schedule a visit tomorrow?',
          testPG.name,
        );
        final updatedChat = appState.getChatForPG(testPG.id, testPG.name);
        expect(
          updatedChat.any((m) => m.text == 'Can I schedule a visit tomorrow?'),
          true,
        );

        // Wait for simulated manager reply
        await Future.delayed(const Duration(milliseconds: 800));
        final afterReply = appState.getChatForPG(testPG.id, testPG.name);
        expect(afterReply.length >= 3, true);
        expect(afterReply.last.sender, MessageSender.landlord);
      },
    );

    test('Biometric Quick Unlock Suite: Toggle preference', () async {
      expect(appState.isBiometricEnabled, false);
      await appState.setBiometricEnabled(true);
      expect(appState.isBiometricEnabled, true);
      expect(prefs.getBool('pgcity_biometric_enabled'), true);

      await appState.setBiometricEnabled(false);
      expect(appState.isBiometricEnabled, false);
      expect(prefs.getBool('pgcity_biometric_enabled'), false);
    });

    test('PG Share Service: Formatted Parent WhatsApp message', () async {
      final pgs = await pgRepo.getAllPGs();
      final testPG = pgs.first;

      final shareText = PGShareService.generateParentShareText(testPG);
      expect(shareText.contains(testPG.name.toUpperCase()), true);
      expect(shareText.contains('Monthly Rent:'), true);
      expect(shareText.contains('Google Maps Location:'), true);
      expect(shareText.contains('PGCity App'), true);
    });

    test('Groq AI Assistant: Message processing and PG matching', () async {
      final pgs = await pgRepo.getAllPGs();
      final aiService = GroqAiService.instance;

      final response = await aiService.sendMessage(
        userMessage: 'Show me girls PGs in Navrangpura',
        conversationHistory: [],
        availablePGs: pgs,
      );

      expect(response.text.isNotEmpty, true);
      expect(response.isUser, false);
      expect(response.id.isNotEmpty, true);
    });
  });
}
