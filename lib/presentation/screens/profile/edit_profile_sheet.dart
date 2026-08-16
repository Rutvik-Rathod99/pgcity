import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class EditProfileSheet extends StatefulWidget {
  final AppState appState;

  const EditProfileSheet({super.key, required this.appState});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _occupationController;
  late TextEditingController _cityController;
  late TextEditingController _emergencyController;
  late String _gender;

  @override
  void initState() {
    super.initState();
    final user = widget.appState.currentUser;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.mobileNumber ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _ageController = TextEditingController(
      text: user != null ? '${user.age}' : '21',
    );
    _occupationController = TextEditingController(text: user?.occupation ?? '');
    _cityController = TextEditingController(
      text: user?.currentCity ?? 'Ahmedabad',
    );
    _emergencyController = TextEditingController(
      text: user?.emergencyContact ?? '',
    );
    _gender = user != null ? user.gender.label : 'Male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _cityController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final cur = widget.appState.currentUser;
    final updated = UserModel(
      id: cur?.id ?? 'usr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameController.text.trim(),
      mobileNumber: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      gender: _gender == 'Female'
          ? UserGender.female
          : (_gender == 'Other' ? UserGender.other : UserGender.male),
      age: int.tryParse(_ageController.text) ?? 21,
      occupation: _occupationController.text.trim(),
      currentCity: _cityController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
      isVerified: cur?.isVerified ?? true,
      createdAt: cur?.createdAt ?? DateTime.now(),
    );

    widget.appState.saveUserProfile(updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: AppColors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          backgroundColor: AppColors.cream,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Edit Profile',
            style: AppTypography.titleMedium(color: AppColors.ink),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 90),
            children: [
              _buildLabel('Full Name'),
              TextFormField(
                controller: _nameController,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(hintText: 'Full Name'),
              ),
              const SizedBox(height: 14),

              _buildLabel('Phone Number'),
              TextFormField(
                controller: _phoneController,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(hintText: '+91 XXXXX XXXXX'),
              ),
              const SizedBox(height: 14),

              _buildLabel('Email Address'),
              TextFormField(
                controller: _emailController,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
                decoration: const InputDecoration(hintText: 'Email'),
              ),
              const SizedBox(height: 14),

              _buildLabel('Gender'),
              Row(
                children: ['Male', 'Female', 'Other'].map((g) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(g),
                      selected: _gender == g,
                      onSelected: (val) {
                        if (val) setState(() => _gender = g);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              _buildLabel('Occupation / College'),
              TextFormField(
                controller: _occupationController,
                decoration: const InputDecoration(
                  hintText: 'College or Company name',
                ),
              ),
              const SizedBox(height: 14),

              _buildLabel('Current City'),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(hintText: 'City'),
              ),
              const SizedBox(height: 14),

              _buildLabel('Emergency Contact (Optional)'),
              TextFormField(
                controller: _emergencyController,
                decoration: const InputDecoration(
                  hintText: 'Parent or Guardian Number',
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
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              child: const Text('Save Profile Changes'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: AppTypography.monoLabel(color: AppColors.inkSoft),
      ),
    );
  }
}
