import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/crashlytics_service.dart';
import 'core/services/biometric_auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'data/repositories/pg_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/enrollment_repository.dart';
import 'presentation/controllers/app_state.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Firebase Crashlytics & Biometrics
  CrashlyticsService.instance.initialize();
  await BiometricAuthService.instance.initialize();
  AppLogger.i('PGCity Ahmedabad application launching...', tag: 'STARTUP');

  // 2. Set system overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFFDF8),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // 3. Initialize persistent local storage
  final prefs = await SharedPreferences.getInstance();

  final pgRepository = PGRepository(prefs);
  final userRepository = UserRepository(prefs);
  final enrollmentRepository = EnrollmentRepository(prefs);

  final appState = AppState(
    pgRepository: pgRepository,
    userRepository: userRepository,
    enrollmentRepository: enrollmentRepository,
    prefs: prefs,
  );

  AppLogger.i('All repositories and AppState initialized.', tag: 'STATE');

  runApp(PGCityApp(appState: appState));
}

class PGCityApp extends StatelessWidget {
  final AppState appState;

  const PGCityApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return MaterialApp(
          title: 'PGCity — PG Discovery & Enrollment',
          debugShowCheckedModeBanner: false,
          themeMode: appState.themeMode,
          theme: AppTheme.lightTheme(appState.appFont),
          darkTheme: AppTheme.darkTheme(appState.appFont),
          home: MainNavigationScreen(appState: appState),
        );
      },
    );
  }
}
