enum FoodHabit { pureVeg, jain, vegEgg, nonVeg }

enum SleepHabit { earlyBird, nightOwl, flexible }

class RoommateModel {
  final String id;
  final String fullName;
  final String gender;
  final int age;
  final String collegeOrCompany;
  final String targetLocality;
  final double budgetMax;
  final FoodHabit foodHabit;
  final SleepHabit sleepHabit;
  final bool isSmokingAllowed;
  final bool isAlcoholAllowed;
  final String bio;
  final String contactNumber;
  final bool isVerifiedStudent;
  final String avatarUrl;
  final DateTime postedAt;

  const RoommateModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.age,
    required this.collegeOrCompany,
    required this.targetLocality,
    required this.budgetMax,
    required this.foodHabit,
    required this.sleepHabit,
    this.isSmokingAllowed = false,
    this.isAlcoholAllowed = false,
    required this.bio,
    required this.contactNumber,
    this.isVerifiedStudent = true,
    required this.avatarUrl,
    required this.postedAt,
  });

  String get foodHabitLabel {
    switch (foodHabit) {
      case FoodHabit.pureVeg:
        return 'Pure Veg';
      case FoodHabit.jain:
        return 'Jain Food Only';
      case FoodHabit.vegEgg:
        return 'Veg + Eggitarian';
      case FoodHabit.nonVeg:
        return 'Non-Veg Friendly';
    }
  }

  String get sleepHabitLabel {
    switch (sleepHabit) {
      case SleepHabit.earlyBird:
        return 'Early Bird (10 PM - 6 AM)';
      case SleepHabit.nightOwl:
        return 'Night Owl (2 AM - 9 AM)';
      case SleepHabit.flexible:
        return 'Flexible Schedule';
    }
  }

  RoommateModel copyWith({
    String? id,
    String? fullName,
    String? gender,
    int? age,
    String? collegeOrCompany,
    String? targetLocality,
    double? budgetMax,
    FoodHabit? foodHabit,
    SleepHabit? sleepHabit,
    bool? isSmokingAllowed,
    bool? isAlcoholAllowed,
    String? bio,
    String? contactNumber,
    bool? isVerifiedStudent,
    String? avatarUrl,
    DateTime? postedAt,
  }) {
    return RoommateModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      collegeOrCompany: collegeOrCompany ?? this.collegeOrCompany,
      targetLocality: targetLocality ?? this.targetLocality,
      budgetMax: budgetMax ?? this.budgetMax,
      foodHabit: foodHabit ?? this.foodHabit,
      sleepHabit: sleepHabit ?? this.sleepHabit,
      isSmokingAllowed: isSmokingAllowed ?? this.isSmokingAllowed,
      isAlcoholAllowed: isAlcoholAllowed ?? this.isAlcoholAllowed,
      bio: bio ?? this.bio,
      contactNumber: contactNumber ?? this.contactNumber,
      isVerifiedStudent: isVerifiedStudent ?? this.isVerifiedStudent,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      postedAt: postedAt ?? this.postedAt,
    );
  }
}
