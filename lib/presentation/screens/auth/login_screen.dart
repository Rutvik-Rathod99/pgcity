import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class LoginScreen extends StatefulWidget {
  final AppState appState;
  final bool isDismissible;

  const LoginScreen({
    super.key,
    required this.appState,
    this.isDismissible = true,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _authModeIndex = 0; // 0: Phone+OTP, 1: Phone+Password, 2: Email+Password

  // Controllers for Phone + OTP
  final TextEditingController _otpPhoneController = TextEditingController(text: '9876543210');
  final List<TextEditingController> _otpDigitControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;
  int _countdown = 30;
  Timer? _timer;

  // Controllers for Phone + Password
  final TextEditingController _passPhoneController = TextEditingController(text: '9876543210');
  final TextEditingController _passController = TextEditingController(text: 'pgcity123');
  bool _obscurePhonePass = true;

  // Controllers for Email + Password
  final TextEditingController _emailController = TextEditingController(text: 'yuvraj.mehta@gmail.com');
  final TextEditingController _emailPassController = TextEditingController(text: 'pgcity123');
  bool _obscureEmailPass = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _timer?.cancel();
    _otpPhoneController.dispose();
    for (final c in _otpDigitControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _passPhoneController.dispose();
    _passController.dispose();
    _emailController.dispose();
    _emailPassController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      _otpSent = true;
      _countdown = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
      }
    });
  }

  void _autoFillDemoOTP() {
    const demoOtp = '482100';
    for (int i = 0; i < 6; i++) {
      _otpDigitControllers[i].text = demoOtp[i];
    }
    setState(() {});
  }

  Future<void> _handlePhoneOtpLogin() async {
    final phone = _otpPhoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      _showToast('Please enter a valid 10-digit phone number', isError: true);
      return;
    }

    if (!_otpSent) {
      _startCountdown();
      widget.appState.requestOTP(phone);
      _showToast('OTP sent to +91 $phone (Demo code: 482100)');
      return;
    }

    final enteredOtp = _otpDigitControllers.map((c) => c.text).join();
    if (enteredOtp.length < 6) {
      _showToast('Please enter the 6-digit OTP', isError: true);
      return;
    }

    if (!widget.appState.verifyOTP(enteredOtp)) {
      _showToast('Invalid OTP. Use demo code 482100', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await widget.appState.loginWithPhoneOtp(phone, enteredOtp);
    setState(() => _isLoading = false);

    if (mounted) {
      _showToast('Welcome back, ${_currentUserOrFallback()}!');
      Navigator.pop(context);
    }
  }

  Future<void> _handlePhonePasswordLogin() async {
    final phone = _passPhoneController.text.trim();
    final pass = _passController.text.trim();

    if (phone.isEmpty || phone.length < 10) {
      _showToast('Please enter a valid mobile number', isError: true);
      return;
    }
    if (pass.isEmpty) {
      _showToast('Please enter your password', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await widget.appState.loginWithPhonePassword(phone, pass);
    setState(() => _isLoading = false);

    if (mounted) {
      _showToast('Welcome back, ${_currentUserOrFallback()}!');
      Navigator.pop(context);
    }
  }

  Future<void> _handleEmailPasswordLogin() async {
    final email = _emailController.text.trim();
    final pass = _emailPassController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showToast('Please enter a valid email address', isError: true);
      return;
    }
    if (pass.isEmpty) {
      _showToast('Please enter your password', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await widget.appState.loginWithEmailPassword(email, pass);
    setState(() => _isLoading = false);

    if (mounted) {
      _showToast('Welcome back, ${_currentUserOrFallback()}!');
      Navigator.pop(context);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    await widget.appState.loginWithGoogle();
    setState(() => _isLoading = false);

    if (mounted) {
      _showToast('Signed in with Google as ${widget.appState.currentUser?.fullName}');
      Navigator.pop(context);
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    await widget.appState.loginWithApple();
    setState(() => _isLoading = false);

    if (mounted) {
      _showToast('Signed in with Apple ID as ${widget.appState.currentUser?.fullName}');
      Navigator.pop(context);
    }
  }

  void _openSignUpSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _SignUpSheet(appState: widget.appState),
    ).then((signedUp) {
      if (signedUp == true && mounted) {
        Navigator.pop(context);
      }
    });
  }

  String _currentUserOrFallback() {
    return widget.appState.currentUser?.fullName ?? 'Resident';
  }

  void _showToast(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.teal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: widget.isDismissible
            ? IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Sign In to PGCity',
          style: AppTypography.titleMedium(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // 1. Header Banner with Brand Mark
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [AppColors.softShadow],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.marigold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Transform.rotate(
                      angle: 0.785398, // 45 degrees
                      child: const Icon(
                        Icons.push_pin_rounded,
                        color: AppColors.navy,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PGCity Ahmedabad',
                          style: AppTypography.displaySmall(color: Colors.white),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Find, verify & enroll in curated PGs across Ahmedabad.',
                          style: AppTypography.bodySmall(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Auth Mode Segmented Selector (Phone OTP, Phone Pass, Email Pass)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  _buildAuthTab(0, 'Phone + OTP', Icons.sms_outlined),
                  _buildAuthTab(1, 'Phone + Pass', Icons.phone_android_rounded),
                  _buildAuthTab(2, 'Email + Pass', Icons.email_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. Dynamic Form Content Based on Selected Tab
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
                boxShadow: const [AppColors.softShadow],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildSelectedAuthForm(),
              ),
            ),
            const SizedBox(height: 22),

            // 4. "OR CONTINUE WITH" Divider
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.line)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'OR CONTINUE WITH',
                    style: AppTypography.monoBadge(color: AppColors.inkSoft).copyWith(fontSize: 10),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.line)),
              ],
            ),
            const SizedBox(height: 18),

            // 5. Google Sign-In Button
            OutlinedButton(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.paper,
                side: const BorderSide(color: AppColors.line, width: 1.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: AppTypography.titleSmall(color: AppColors.ink),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 6. Apple Sign-In Button (Apple App Store Guideline 5.1.1(v) Compliant)
            ElevatedButton(
              onPressed: _isLoading ? null : _handleAppleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.apple_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Sign in with Apple',
                    style: AppTypography.titleSmall(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 7. Sign Up & Guest Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: AppTypography.bodySmall(color: AppColors.inkSoft),
                ),
                GestureDetector(
                  onTap: _openSignUpSheet,
                  child: Text(
                    'Create Account',
                    style: AppTypography.titleSmall(color: AppColors.marigoldDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (widget.isDismissible)
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Skip & Explore as Guest →',
                    style: AppTypography.bodySmall(color: AppColors.inkSoft),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthTab(int index, String label, IconData icon) {
    final isSelected = _authModeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _authModeIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.marigold : AppColors.inkSoft,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.inkSoft,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedAuthForm() {
    switch (_authModeIndex) {
      case 0:
        return _buildPhoneOtpForm();
      case 1:
        return _buildPhonePasswordForm();
      case 2:
        return _buildEmailPasswordForm();
      default:
        return _buildPhoneOtpForm();
    }
  }

  // Form 1: Mobile Number + OTP
  Widget _buildPhoneOtpForm() {
    return Column(
      key: const ValueKey('phone_otp_form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number & SMS OTP',
          style: AppTypography.titleMedium(color: AppColors.ink),
        ),
        const SizedBox(height: 4),
        Text(
          'Enter your 10-digit mobile number to receive a secure OTP verification code.',
          style: AppTypography.bodySmall(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 14),

        // Phone Input
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                '🇮🇳 +91',
                style: AppTypography.titleSmall(color: AppColors.ink),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _otpPhoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: '9876543210',
                  counterText: '',
                ),
              ),
            ),
          ],
        ),

        if (_otpSent) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Enter 6-Digit OTP',
                style: AppTypography.titleSmall(color: AppColors.ink),
              ),
              Text(
                _countdown > 0 ? 'Resend in ${_countdown}s' : 'Code Expired',
                style: AppTypography.monoBadge(color: AppColors.teal),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 6-digit OTP code boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 44,
                height: 50,
                child: TextField(
                  controller: _otpDigitControllers[index],
                  focusNode: _otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: AppTypography.titleMedium(color: AppColors.navy).copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                    fillColor: AppColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.line),
                    ),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && index < 5) {
                      _otpFocusNodes[index + 1].requestFocus();
                    } else if (val.isEmpty && index > 0) {
                      _otpFocusNodes[index - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 10),

          // Demo Auto-fill Helper
          Center(
            child: TextButton.icon(
              onPressed: _autoFillDemoOTP,
              icon: const Icon(Icons.bolt_rounded, size: 16, color: AppColors.marigoldDark),
              label: Text(
                'Auto-fill Demo Code (482100)',
                style: AppTypography.monoBadge(color: AppColors.marigoldDark),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Action Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePhoneOtpLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.marigold,
              foregroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
                  )
                : Text(
                    _otpSent ? 'Verify OTP & Sign In' : 'Send OTP Code',
                    style: AppTypography.button(color: AppColors.navy),
                  ),
          ),
        ),
      ],
    );
  }

  // Form 2: Mobile Number + Password
  Widget _buildPhonePasswordForm() {
    return Column(
      key: const ValueKey('phone_pass_form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mobile Number & Password',
          style: AppTypography.titleMedium(color: AppColors.ink),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in with your registered phone number and account password.',
          style: AppTypography.bodySmall(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 14),

        // Phone Input
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(
                '🇮🇳 +91',
                style: AppTypography.titleSmall(color: AppColors.ink),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _passPhoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: '9876543210',
                  counterText: '',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Password Input
        TextField(
          controller: _passController,
          obscureText: _obscurePhonePass,
          decoration: InputDecoration(
            hintText: 'Enter account password',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.inkSoft),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePhonePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: AppColors.inkSoft,
              ),
              onPressed: () => setState(() => _obscurePhonePass = !_obscurePhonePass),
            ),
          ),
        ),
        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePhonePasswordLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.marigold,
              foregroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
                  )
                : Text(
                    'Sign In with Password',
                    style: AppTypography.button(color: AppColors.navy),
                  ),
          ),
        ),
      ],
    );
  }

  // Form 3: Email + Password
  Widget _buildEmailPasswordForm() {
    return Column(
      key: const ValueKey('email_pass_form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address & Password',
          style: AppTypography.titleMedium(color: AppColors.ink),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in with your email credentials.',
          style: AppTypography.bodySmall(color: AppColors.inkSoft),
        ),
        const SizedBox(height: 14),

        // Email Input
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'student@example.com',
            prefixIcon: Icon(Icons.email_outlined, size: 20, color: AppColors.inkSoft),
          ),
        ),
        const SizedBox(height: 12),

        // Password Input
        TextField(
          controller: _emailPassController,
          obscureText: _obscureEmailPass,
          decoration: InputDecoration(
            hintText: 'Enter password',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.inkSoft),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureEmailPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20,
                color: AppColors.inkSoft,
              ),
              onPressed: () => setState(() => _obscureEmailPass = !_obscureEmailPass),
            ),
          ),
        ),
        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => _showToast('Demo reset link sent to ${_emailController.text}'),
            child: Text(
              'Forgot Password?',
              style: AppTypography.bodySmall(color: AppColors.marigoldDark),
            ),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailPasswordLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.marigold,
              foregroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
                  )
                : Text(
                    'Sign In with Email',
                    style: AppTypography.button(color: AppColors.navy),
                  ),
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Quick User Registration Modal
// -----------------------------------------------------------------------------
class _SignUpSheet extends StatefulWidget {
  final AppState appState;

  const _SignUpSheet({required this.appState});

  @override
  State<_SignUpSheet> createState() => _SignUpSheetState();
}

class _SignUpSheetState extends State<_SignUpSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _occupationController = TextEditingController(text: 'Ahmedabad University');
  UserGender _gender = UserGender.male;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _submitRegister() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      _showToast('Please enter your full name', isError: true);
      return;
    }
    if (phone.isEmpty || phone.length < 10) {
      _showToast('Please enter a valid mobile number', isError: true);
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showToast('Please enter a valid email', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    await widget.appState.registerUser(
      fullName: name,
      mobileNumber: phone.startsWith('+') ? phone : '+91 $phone',
      email: email,
      occupation: _occupationController.text.trim(),
      gender: _gender,
      authProvider: AuthProvider.phoneOtp,
    );
    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _showToast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.error : AppColors.teal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create PGCity Account',
                style: AppTypography.titleLarge(color: AppColors.ink),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'e.g. Yuvraj Mehta',
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Mobile Number',
              hintText: '9876543210',
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'yuvraj@gmail.com',
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _occupationController,
            decoration: const InputDecoration(
              labelText: 'College / Workplace',
              hintText: 'e.g. Nirma University / TCS',
            ),
          ),
          const SizedBox(height: 12),

          Text('Gender', style: AppTypography.titleSmall()),
          const SizedBox(height: 6),
          Row(
            children: [
              _buildGenderChip(UserGender.male),
              const SizedBox(width: 8),
              _buildGenderChip(UserGender.female),
              const SizedBox(width: 8),
              _buildGenderChip(UserGender.other),
            ],
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.marigold,
                foregroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
                    )
                  : Text(
                      'Create Account & Sign In',
                      style: AppTypography.button(color: AppColors.navy),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderChip(UserGender g) {
    final isSelected = _gender == g;
    return ChoiceChip(
      label: Text(g.label),
      selected: isSelected,
      selectedColor: AppColors.navy,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.inkSoft,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      onSelected: (_) => setState(() => _gender = g),
    );
  }
}
