import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/enrollment_model.dart';

class EnrollmentRepository {
  static const String _enrollKey = 'pgcity_user_enrollments_v1';

  final SharedPreferences _prefs;

  EnrollmentRepository(this._prefs);

  List<EnrollmentModel> getAllEnrollments() {
    final raw = _prefs.getString(_enrollKey);
    if (raw == null) {
      // Seed default initial enrollments matching PRD Screen 6
      final defaults = [
        EnrollmentModel(
          id: 'enr_sunrise_001',
          userId: 'usr_yuvraj_01',
          pgId: 'pg_sunrise_girls',
          pgName: 'Sunrise Girls PG',
          pgType: 'Girls PG',
          pgRent: 8500,
          applicantName: 'Yuvraj Mehta',
          applicantPhone: '+91 98765 43210',
          applicantEmail: 'yuvraj@email.com',
          applicantGender: 'Male',
          applicantAge: 21,
          occupation: 'XYZ College of Engineering',
          moveInDate: DateTime.now().add(const Duration(days: 28)),
          sharingType: '2 Sharing',
          message: 'Looking for a clean room with quiet study area near CEPT.',
          status: EnrollmentStatus.underReview,
          submittedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        EnrollmentModel(
          id: 'enr_green_002',
          userId: 'usr_yuvraj_01',
          pgId: 'pg_green_residency',
          pgName: 'Green Residency PG',
          pgType: 'Boys PG',
          pgRent: 9200,
          applicantName: 'Yuvraj Mehta',
          applicantPhone: '+91 98765 43210',
          applicantEmail: 'yuvraj@email.com',
          applicantGender: 'Male',
          applicantAge: 21,
          occupation: 'XYZ College of Engineering',
          moveInDate: DateTime.now().add(const Duration(days: 14)),
          sharingType: '1 & 2 Sharing',
          message: 'Need parking spot for bike.',
          status: EnrollmentStatus.accepted,
          submittedAt: DateTime.now().subtract(const Duration(days: 14)),
        ),
      ];
      saveAllEnrollments(defaults);
      return defaults;
    }

    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => EnrollmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAllEnrollments(List<EnrollmentModel> list) async {
    await _prefs.setString(
      _enrollKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addEnrollment(EnrollmentModel item) async {
    final all = getAllEnrollments();
    all.insert(0, item);
    await saveAllEnrollments(all);
  }

  Future<void> updateStatus(
    String enrollmentId,
    EnrollmentStatus status, {
    String? adminNote,
  }) async {
    final all = getAllEnrollments();
    final index = all.indexWhere((e) => e.id == enrollmentId);
    if (index >= 0) {
      all[index] = all[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
        adminNote: adminNote,
      );
      await saveAllEnrollments(all);
    }
  }

  Future<void> deleteEnrollment(String id) async {
    final all = getAllEnrollments();
    all.removeWhere((e) => e.id == id);
    await saveAllEnrollments(all);
  }
}
