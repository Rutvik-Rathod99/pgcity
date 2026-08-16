import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'otp_verification_screen.dart';
import 'enrollment_success_dialog.dart';

class EnrollmentSheet extends StatefulWidget {
  final PGModel pg;
  final AppState appState;

  const EnrollmentSheet({super.key, required this.pg, required this.appState});

  @override
  State<EnrollmentSheet> createState() => _EnrollmentSheetState();
}

class _EnrollmentSheetState extends State<EnrollmentSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _occupationController;
  late TextEditingController _messageController;

  late String _selectedGender;
  late String _selectedSharing;
  late DateTime _selectedMoveInDate;

  @override
  void initState() {
    super.initState();
    final user = widget.appState.currentUser;

    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(
      text: user?.mobileNumber ?? '+91 98765 43210',
    );
    _emailController = TextEditingController(
      text: user?.email ?? 'yuvraj@email.com',
    );
    _ageController = TextEditingController(
      text: user != null ? '${user.age}' : '21',
    );
    _occupationController = TextEditingController(
      text: user?.occupation ?? 'XYZ College of Engineering',
    );
    _messageController = TextEditingController();

    _selectedGender = user != null ? user.gender.label : 'Male';
    _selectedSharing = user?.preferredSharing ?? '2 Sharing';
    _selectedMoveInDate =
        user?.moveInDate ?? DateTime.now().add(const Duration(days: 30));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectMoveInDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMoveInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navy,
              onPrimary: Colors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedMoveInDate = picked);
    }
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;

    final user = widget.appState.currentUser;
    final phone = _phoneController.text.trim();
    final isAlreadyVerified =
        user?.isVerified == true && user?.mobileNumber == phone;

    // Save/Update user profile model
    final updatedUser = UserModel(
      id: user?.id ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameController.text.trim(),
      mobileNumber: phone,
      email: _emailController.text.trim(),
      gender: _selectedGender == 'Female'
          ? UserGender.female
          : (_selectedGender == 'Other' ? UserGender.other : UserGender.male),
      age: int.tryParse(_ageController.text) ?? 21,
      occupation: _occupationController.text.trim(),
      moveInDate: _selectedMoveInDate,
      preferredSharing: _selectedSharing,
      isVerified: isAlreadyVerified,
      createdAt: user?.createdAt ?? DateTime.now(),
    );

    widget.appState.saveUserProfile(updatedUser);

    if (!isAlreadyVerified) {
      // Navigate to OTP verification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(
            pg: widget.pg,
            applicantName: _nameController.text.trim(),
            phoneNumber: phone,
            email: _emailController.text.trim(),
            gender: _selectedGender,
            age: int.tryParse(_ageController.text) ?? 21,
            occupation: _occupationController.text.trim(),
            moveInDate: _selectedMoveInDate,
            sharingType: _selectedSharing,
            message: _messageController.text.trim(),
            appState: widget.appState,
          ),
        ),
      );
    } else {
      // Directly submit enrollment
      widget.appState.submitEnrollment(
        pg: widget.pg,
        applicantName: _nameController.text.trim(),
        applicantPhone: phone,
        applicantEmail: _emailController.text.trim(),
        applicantGender: _selectedGender,
        applicantAge: int.tryParse(_ageController.text) ?? 21,
        occupation: _occupationController.text.trim(),
        moveInDate: _selectedMoveInDate,
        sharingType: _selectedSharing,
        message: _messageController.text.trim(),
      );

      Navigator.pop(context); // Close sheet
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => EnrollmentSuccessDialog(
          pg: widget.pg,
          applicantName: _nameController.text.trim(),
          moveInDate: _selectedMoveInDate,
          sharingType: _selectedSharing,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Scaffold(
        backgroundColor: context.appBg,
        appBar: AppBar(
          backgroundColor: context.appBg,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 20,
              color: isDark ? Colors.white : AppColors.ink,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enroll — ${widget.pg.name}',
                style: AppTypography.titleSmall(
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Step 1 of 2 · Your Details',
                style: AppTypography.bodySmall(
                  color: isDark ? Colors.white60 : AppColors.inkSoft,
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
            children: [
              // Saved Profile Notice
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F3934) : AppColors.tealLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.teal.withAlpha(isDark ? 100 : 75),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.flash_on_rounded,
                      size: 16,
                      color: AppColors.teal,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Details pre-filled from your saved profile.',
                        style: AppTypography.bodySmall(
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : AppColors.teal,
                        ).copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              // Full Name
              _buildFieldLabel('Full Name', isDark),
              TextFormField(
                controller: _nameController,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(hintText: 'Enter full name'),
              ),
              const SizedBox(height: 14),

              // Mobile Number
              _buildFieldLabel('Mobile Number', isDark),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(hintText: '+91 XXXXX XXXXX'),
              ),
              const SizedBox(height: 14),

              // Email
              _buildFieldLabel('Email Address', isDark),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(
                  hintText: 'Enter email address',
                ),
              ),
              const SizedBox(height: 14),

              // Gender Selector Chips
              _buildFieldLabel('Gender', isDark),
              Row(
                children: ['Male', 'Female', 'Other'].map((g) {
                  final isSel = _selectedGender == g;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(g),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setState(() => _selectedGender = g);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Age & Move-in Date Row
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Age', isDark),
                        TextFormField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white : AppColors.ink,
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'Required' : null,
                          decoration: const InputDecoration(hintText: '21'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Move-in Date', isDark),
                        InkWell(
                          onTap: _selectMoveInDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: context.appBorder),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(_selectedMoveInDate),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.ink,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 18,
                                  color: isDark
                                      ? Colors.white60
                                      : AppColors.inkSoft,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Sharing Preference Chips
              _buildFieldLabel('Preferred Sharing', isDark),
              Row(
                children: ['1 Sharing', '2 Sharing', '3 Sharing'].map((s) {
                  final isSel = _selectedSharing == s;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(s),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setState(() => _selectedSharing = s);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Occupation / College Name
              _buildFieldLabel('Occupation / College Name', isDark),
              TextFormField(
                controller: _occupationController,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                decoration: const InputDecoration(
                  hintText: 'e.g. CEPT University or TCS Gandhinagar',
                ),
              ),
              const SizedBox(height: 14),

              // Message (Optional)
              _buildFieldLabel(
                'Message for Property Manager (Optional)',
                isDark,
              ),
              TextFormField(
                controller: _messageController,
                maxLines: 3,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
                decoration: const InputDecoration(
                  hintText: 'Any special requirements or dietary preferences?',
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).padding.bottom + 12,
          ),
          decoration: BoxDecoration(
            color: context.appSurface,
            border: Border(top: BorderSide(color: context.appBorder)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _onContinue,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Continue to Confirmation'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppTypography.monoLabel(
          color: isDark ? Colors.white70 : AppColors.inkSoft,
        ),
      ),
    );
  }
}
