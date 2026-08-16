enum EnrollmentStatus {
  submitted('Submitted'),
  underReview('Under review'),
  accepted('Accepted'),
  rejected('Rejected'),
  cancelled('Cancelled');

  final String label;
  const EnrollmentStatus(this.label);

  static EnrollmentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'under review':
      case 'underreview':
        return EnrollmentStatus.underReview;
      case 'accepted':
        return EnrollmentStatus.accepted;
      case 'rejected':
        return EnrollmentStatus.rejected;
      case 'cancelled':
        return EnrollmentStatus.cancelled;
      default:
        return EnrollmentStatus.submitted;
    }
  }
}

class EnrollmentModel {
  final String id;
  final String userId;
  final String pgId;
  final String pgName;
  final String pgType;
  final double pgRent;
  final String applicantName;
  final String applicantPhone;
  final String applicantEmail;
  final String applicantGender;
  final int applicantAge;
  final String occupation;
  final DateTime moveInDate;
  final String sharingType;
  final String message;
  final EnrollmentStatus status;
  final DateTime submittedAt;
  final DateTime? updatedAt;
  final String? adminNote;

  const EnrollmentModel({
    required this.id,
    required this.userId,
    required this.pgId,
    required this.pgName,
    required this.pgType,
    required this.pgRent,
    required this.applicantName,
    required this.applicantPhone,
    required this.applicantEmail,
    required this.applicantGender,
    required this.applicantAge,
    required this.occupation,
    required this.moveInDate,
    required this.sharingType,
    this.message = '',
    this.status = EnrollmentStatus.submitted,
    required this.submittedAt,
    this.updatedAt,
    this.adminNote,
  });

  EnrollmentModel copyWith({
    String? id,
    String? userId,
    String? pgId,
    String? pgName,
    String? pgType,
    double? pgRent,
    String? applicantName,
    String? applicantPhone,
    String? applicantEmail,
    String? applicantGender,
    int? applicantAge,
    String? occupation,
    DateTime? moveInDate,
    String? sharingType,
    String? message,
    EnrollmentStatus? status,
    DateTime? submittedAt,
    DateTime? updatedAt,
    String? adminNote,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pgId: pgId ?? this.pgId,
      pgName: pgName ?? this.pgName,
      pgType: pgType ?? this.pgType,
      pgRent: pgRent ?? this.pgRent,
      applicantName: applicantName ?? this.applicantName,
      applicantPhone: applicantPhone ?? this.applicantPhone,
      applicantEmail: applicantEmail ?? this.applicantEmail,
      applicantGender: applicantGender ?? this.applicantGender,
      applicantAge: applicantAge ?? this.applicantAge,
      occupation: occupation ?? this.occupation,
      moveInDate: moveInDate ?? this.moveInDate,
      sharingType: sharingType ?? this.sharingType,
      message: message ?? this.message,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      adminNote: adminNote ?? this.adminNote,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'pgId': pgId,
    'pgName': pgName,
    'pgType': pgType,
    'pgRent': pgRent,
    'applicantName': applicantName,
    'applicantPhone': applicantPhone,
    'applicantEmail': applicantEmail,
    'applicantGender': applicantGender,
    'applicantAge': applicantAge,
    'occupation': occupation,
    'moveInDate': moveInDate.toIso8601String(),
    'sharingType': sharingType,
    'message': message,
    'status': status.name,
    'submittedAt': submittedAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'adminNote': adminNote,
  };

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      pgId: json['pgId'] as String,
      pgName: json['pgName'] as String,
      pgType: json['pgType'] as String,
      pgRent: (json['pgRent'] as num).toDouble(),
      applicantName: json['applicantName'] as String,
      applicantPhone: json['applicantPhone'] as String,
      applicantEmail: json['applicantEmail'] as String,
      applicantGender: json['applicantGender'] as String,
      applicantAge: json['applicantAge'] as int,
      occupation: json['occupation'] as String,
      moveInDate: DateTime.parse(json['moveInDate'] as String),
      sharingType: json['sharingType'] as String,
      message: (json['message'] as String?) ?? '',
      status: EnrollmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EnrollmentStatus.submitted,
      ),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      adminNote: json['adminNote'] as String?,
    );
  }
}
