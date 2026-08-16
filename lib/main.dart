import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/pg_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/enrollment_repository.dart';
import 'presentation/controllers/app_state.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Android system overlay style (light navigation bar and dark icons)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFFFFDF8),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize persistent local storage
  final prefs = await SharedPreferences.getInstance();

  final pgRepository = PGRepository(prefs);
  final userRepository = UserRepository(prefs);
  final enrollmentRepository = EnrollmentRepository(prefs);

  final appState = AppState(
    pgRepository: pgRepository,
    userRepository: userRepository,
    enrollmentRepository: enrollmentRepository,
  );

  runApp(PGCityApp(appState: appState));
}

class PGCityApp extends StatelessWidget {
  final AppState appState;

  const PGCityApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PGCity — PG Discovery & Enrollment',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainNavigationScreen(appState: appState),
    );
  }
}
