import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'enrollment_success_dialog.dart';

class OTPVerificationScreen extends StatefulWidget {
  final PGModel pg;
  final String applicantName;
  final String phoneNumber;
  final String email;
  final String gender;
  final int age;
  final String occupation;
  final DateTime moveInDate;
  final String sharingType;
  final String message;
  final AppState appState;

  const OTPVerificationScreen({
    super.key,
    required this.pg,
    required this.applicantName,
    required this.phoneNumber,
    required this.email,
    required this.gender,
    required this.age,
    required this.occupation,
    required this.moveInDate,
    required this.sharingType,
    required this.message,
    required this.appState,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendSeconds = 28;
  Timer? _timer;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Generate initial OTP code for phone
    widget.appState.requestOTP(widget.phoneNumber);

    // Auto focus first box
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    _resendSeconds = 28;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _enteredCode => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyAndSubmit();
      }
    }
  }

  Future<void> _verifyAndSubmit() async {
    final code = _enteredCode;
    if (code.length < 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final isValid = widget.appState.verifyOTP(code);
    if (!isValid) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Invalid code. Use demo OTP: 482100';
      });
      return;
    }

    // Submit enrollment
    await widget.appState.submitEnrollment(
      pg: widget.pg,
      applicantName: widget.applicantName,
      applicantPhone: widget.phoneNumber,
      applicantEmail: widget.email,
      applicantGender: widget.gender,
      applicantAge: widget.age,
      occupation: widget.occupation,
      moveInDate: widget.moveInDate,
      sharingType: widget.sharingType,
      message: widget.message,
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      // Pop verification screen and show rich confirmation dialog
      Navigator.pop(context); // Pop OTP Screen
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => EnrollmentSuccessDialog(
          pg: widget.pg,
          applicantName: widget.applicantName,
          moveInDate: widget.moveInDate,
          sharingType: widget.sharingType,
        ),
      );
    }
  }

  void _autofillDemoCode() {
    const demo = '482100';
    for (int i = 0; i < 6; i++) {
      _controllers[i].text = demo[i];
    }
    _verifyAndSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Verify your number',
          style: AppTypography.titleMedium(color: AppColors.ink),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shield Icon Banner (Screen 5)
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.tealLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_rounded,
                color: AppColors.teal,
                size: 24,
              ),
            ),
            const SizedBox(height: 18),

            Text(
              'Enter the 6-digit code',
              style: AppTypography.displaySmall(color: AppColors.ink),
            ),
            const SizedBox(height: 6),
            RichText(
              text: TextSpan(
                style: AppTypography.bodyMedium(color: AppColors.inkSoft),
                children: [
                  const TextSpan(text: 'Sent to '),
                  TextSpan(
                    text: widget.phoneNumber,
                    style: AppTypography.monoPrice(color: AppColors.navy)
                        .copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 6 OTP Digit Input Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 44,
                  height: 52,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: AppTypography.monoPrice(color: AppColors.navy)
                        .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.paper,
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.line),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.marigold,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      } else {
                        _onDigitChanged(index, val);
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),

            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
              const SizedBox(height: 8),
            ],

            // Resend timer and Demo Autofill Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _resendSeconds > 0
                      ? 'Resend OTP in 00:${_resendSeconds.toString().padLeft(2, '0')}'
                      : 'Didn\'t get OTP?',
                  style: AppTypography.bodySmall(color: AppColors.inkSoft),
                ),
                if (_resendSeconds == 0)
                  TextButton(
                    onPressed: () {
                      widget.appState.requestOTP(widget.phoneNumber);
                      _startResendTimer();
                    },
                    child: Text(
                      'Resend Code',
                      style: AppTypography.button(color: AppColors.teal),
                    ),
                  )
                else
                  TextButton.icon(
                    onPressed: _autofillDemoCode,
                    icon: const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.marigoldDark),
                    label: Text(
                      'Demo Fill (482100)',
                      style: AppTypography.monoBadge(color: AppColors.marigoldDark)
                          .copyWith(fontSize: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _verifyAndSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.navy,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text('Verify & Submit Enrollment'),
              ),
            ),
            const SizedBox(height: 24),

            // Info note matching Screen 5 in PRD
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.teal, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Your personal details will be securely saved to your profile so you never need to type them again.',
                      style: AppTypography.bodySmall(color: AppColors.inkSoft),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
