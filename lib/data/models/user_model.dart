enum UserGender {
  male('Male'),
  female('Female'),
  other('Other');

  final String label;
  const UserGender(this.label);
}

class UserModel {
  final String id;
  final String fullName;
  final String mobileNumber;
  final String email;
  final UserGender gender;
  final int age;
  final String occupation; // e.g. "XYZ College of Engineering" or "Software Engineer"
  final String? profilePhoto;
  final bool isVerified;
  final DateTime? moveInDate;
  final String preferredSharing;
  final String currentCity;
  final String emergencyContact;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    this.gender = UserGender.male,
    this.age = 21,
    required this.occupation,
    this.profilePhoto,
    this.isVerified = false,
    this.moveInDate,
    this.preferredSharing = '2 Sharing',
    this.currentCity = 'Ahmedabad',
    this.emergencyContact = '',
    required this.createdAt,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName.substring(0, 1).toUpperCase() : 'U';
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? mobileNumber,
    String? email,
    UserGender? gender,
    int? age,
    String? occupation,
    String? profilePhoto,
    bool? isVerified,
    DateTime? moveInDate,
    String? preferredSharing,
    String? currentCity,
    String? emergencyContact,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isVerified: isVerified ?? this.isVerified,
      moveInDate: moveInDate ?? this.moveInDate,
      preferredSharing: preferredSharing ?? this.preferredSharing,
      currentCity: currentCity ?? this.currentCity,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'mobileNumber': mobileNumber,
    'email': email,
    'gender': gender.name,
    'age': age,
    'occupation': occupation,
    'profilePhoto': profilePhoto,
    'isVerified': isVerified,
    'moveInDate': moveInDate?.toIso8601String(),
    'preferredSharing': preferredSharing,
    'currentCity': currentCity,
    'emergencyContact': emergencyContact,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      mobileNumber: json['mobileNumber'] as String,
      email: json['email'] as String,
      gender: UserGender.values.firstWhere(
        (e) => e.name == json['gender'],
        orElse: () => UserGender.male,
      ),
      age: json['age'] as int? ?? 21,
      occupation: json['occupation'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      moveInDate: json['moveInDate'] != null ? DateTime.parse(json['moveInDate'] as String) : null,
      preferredSharing: json['preferredSharing'] as String? ?? '2 Sharing',
      currentCity: json['currentCity'] as String? ?? 'Ahmedabad',
      emergencyContact: json['emergencyContact'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
