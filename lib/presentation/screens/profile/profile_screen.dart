import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/data/models/user_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'package:pgcity/presentation/screens/auth/login_screen.dart';
import 'edit_profile_sheet.dart';
import 'privacy_policy_modal.dart';
import 'help_support_modal.dart';
import 'terms_conditions_modal.dart';
import 'in_app_rating_modal.dart';
import 'theme_font_settings_modal.dart';
import 'package:pgcity/presentation/screens/admin/admin_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  void _openLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(appState: appState)),
    );
  }

  void _openEditProfile(BuildContext context) {
    if (!appState.isLoggedIn) {
      _openLoginScreen(context);
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditProfileSheet(appState: appState),
    );
  }

  void _openAppearanceSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ThemeFontSettingsModal(appState: appState),
    );
  }

  void _openInAppRating(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color ?? AppColors.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => InAppRatingModal(appState: appState),
    );
  }

  void _openTermsConditions(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TermsConditionsModal()),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PrivacyPolicyModal()),
    );
  }

  void _openHelpSupport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const HelpSupportModal()),
    );
  }

  void _confirmLogout(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Log Out from PGCity?',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        content: Text(
          'You will be signed out on this device. You can explore PGs as a guest or sign in anytime.',
          style: AppTypography.bodySmall(
            color: isDark ? Colors.white70 : AppColors.inkSoft,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await appState.logoutUser();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully.'),
                    backgroundColor: AppColors.navy,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  // Apple-Specific Account Deletion (Apple App Store Review Guideline 5.1.1(v))
  void _confirmDeleteAppleAccount(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.apple_rounded,
              color: isDark ? Colors.white : Colors.black,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Delete Apple Account?',
                style: AppTypography.titleMedium(color: AppColors.error),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Under Apple App Store Guideline 5.1.1(v) and DPDP Act 2023:',
              style: AppTypography.titleSmall(
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Your Apple Sign-In authorization token will be permanently revoked.\n'
              '• All profile information, saved bookings, unlocked owner contacts, and enrollment history will be erased from our servers immediately.\n'
              '• This action is permanent and irreversible.',
              style: AppTypography.bodySmall(
                color: isDark ? Colors.white70 : AppColors.inkSoft,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await appState.deleteAppleAccount();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Apple ID account & tokens permanently deleted.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Apple Account'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account?',
          style: AppTypography.titleMedium(color: AppColors.error),
        ),
        content: Text(
          'Under the DPDP Act 2023, this will permanently erase your profile, personal details, unlocked contact history, and enrollment records from our servers. This action cannot be undone.',
          style: AppTypography.bodySmall(
            color: isDark ? Colors.white70 : AppColors.inkSoft,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await appState.deleteAccount();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account and data permanently erased.'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = appState.currentUser;
    final isLoggedIn = appState.isLoggedIn;
    final enrollments = appState.enrollments;

    final themeLabel = appState.themeMode == ThemeMode.system
        ? 'System Auto'
        : (appState.themeMode == ThemeMode.dark ? 'Dark Mode' : 'Light Mode');
    final fontLabel = appState.appFont.label;
    final langLabel = '${appState.appLanguage.flag} ${appState.appLanguage.label}';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.cream,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.cream,
        elevation: 0,
        title: Text(
          appState.tr('my_profile'),
          style: AppTypography.displaySmall(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.admin_panel_settings_rounded,
              color: AppColors.navy,
            ),
            tooltip: 'Admin Management',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AdminDashboardScreen(appState: appState),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
        children: [
          // 1. User Header with Initials / Guest Banner
          if (!isLoggedIn)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [AppColors.softShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.marigold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.navy,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.tr('guest_user'),
                              style: AppTypography.titleMedium(color: Colors.white),
                            ),
                            Text(
                              appState.tr('sign_in_desc'),
                              style: AppTypography.bodySmall(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openLoginScreen(context),
                      icon: const Icon(Icons.login_rounded, size: 16),
                      label: Text(appState.tr('sign_in_cta')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.marigold,
                        foregroundColor: AppColors.navy,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),
                boxShadow: const [AppColors.softShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar Circle with Marigold Initials on Navy
                      Container(
                        width: 54,
                        height: 54,
                        decoration: const BoxDecoration(
                          color: AppColors.navy,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user?.initials ?? 'G',
                            style: AppTypography.displaySmall(
                              color: AppColors.marigold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    user?.fullName ?? 'Resident',
                                    style: AppTypography.titleMedium(
                                      color: isDark ? Colors.white : AppColors.ink,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (user?.isVerified == true) ...[
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.verified_rounded,
                                    size: 16,
                                    color: AppColors.teal,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.mobileNumber.isNotEmpty == true
                                  ? user!.mobileNumber
                                  : (user?.email ?? 'No contact saved'),
                              style: AppTypography.bodySmall(
                                color: isDark ? Colors.white70 : AppColors.inkSoft,
                              ),
                            ),
                            Text(
                              user?.occupation ?? 'Student / Professional',
                              style: AppTypography.bodySmall(
                                color: AppColors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _openEditProfile(context),
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: isDark ? Colors.white : AppColors.navy,
                        ),
                        tooltip: 'Edit Profile',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Auth Provider Tag Chip
                  _buildAuthProviderBadge(user?.authProvider ?? AuthProvider.phoneOtp),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // 2. My Enrollments Section
          Text(
            '${appState.tr('my_enrollments')} (${enrollments.length})',
            style: AppTypography.titleLarge(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),

          if (enrollments.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.assignment_late_outlined,
                      color: AppColors.inkSoft,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No Enrollment Requests Yet',
                      style: AppTypography.titleSmall(color: AppColors.inkSoft),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Explore PGs and tap "Enroll Now" to apply.',
                      style: AppTypography.bodySmall(color: AppColors.inkSoft),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: enrollments.map((enr) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : AppColors.line,
                    ),
                    boxShadow: const [AppColors.softShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  enr.pgName,
                                  style: AppTypography.titleMedium(
                                    color: isDark ? Colors.white : AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Submitted ${DateFormat('dd MMM yyyy').format(enr.submittedAt)} · ${enr.sharingType}',
                                  style: AppTypography.bodySmall(
                                    color: isDark ? Colors.white70 : AppColors.inkSoft,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildStatusBadge(enr.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Move-in: ${DateFormat('dd MMM yyyy').format(enr.moveInDate)}',
                            style: AppTypography.monoBadge(
                              color: isDark ? Colors.white70 : AppColors.inkSoft,
                            ).copyWith(fontSize: 10),
                          ),
                          Text(
                            CurrencyFormatter.format(enr.pgRent),
                            style: AppTypography.monoPrice(
                              color: AppColors.teal,
                            ).copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),

          // 3. Appearance & Preferences Section
          Text(
            appState.tr('account_settings'),
            style: AppTypography.titleLarge(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : AppColors.line,
              ),
            ),
            child: Column(
              children: [
                // Theme, Font & Language Selection
                _buildAccountTile(
                  icon: Icons.palette_outlined,
                  title: 'Theme, Font & Language',
                  subtitle: '$themeLabel · $fontLabel · $langLabel',
                  iconColor: AppColors.marigoldDark,
                  isDark: isDark,
                  onTap: () => _openAppearanceSettings(context),
                ),
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),

                // In-App Rating
                _buildAccountTile(
                  icon: Icons.star_rate_rounded,
                  title: appState.tr('in_app_rating'),
                  subtitle: appState.userAppRating != null
                      ? 'Your Rating: ${'⭐' * appState.userAppRating!}'
                      : '5-star feedback & reviews',
                  iconColor: AppColors.marigold,
                  isDark: isDark,
                  onTap: () => _openInAppRating(context),
                ),
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),

                // Terms and Conditions
                _buildAccountTile(
                  icon: Icons.description_outlined,
                  title: appState.tr('terms_conditions'),
                  subtitle: '7-clause terms of service & user rules',
                  isDark: isDark,
                  onTap: () => _openTermsConditions(context),
                ),
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),

                // Privacy Policy & DPDP
                _buildAccountTile(
                  icon: Icons.privacy_tip_outlined,
                  title: appState.tr('privacy_policy'),
                  subtitle: 'Digital Personal Data Protection Act 2023',
                  isDark: isDark,
                  onTap: () => _openPrivacyPolicy(context),
                ),
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),

                // Help & Support
                _buildAccountTile(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help, FAQ & WhatsApp Support',
                  subtitle: 'Direct support team in Ahmedabad',
                  isDark: isDark,
                  onTap: () => _openHelpSupport(context),
                ),
                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),

                // Admin Portal
                _buildAccountTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: appState.tr('admin_portal'),
                  subtitle: 'PG inventory management & lead review',
                  isDark: isDark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AdminDashboardScreen(appState: appState),
                      ),
                    );
                  },
                ),

                // Apple-Only Account Deletion (Apple App Store Guideline 5.1.1(v))
                if (user?.isAppleUser == true) ...[
                  Divider(
                    height: 1,
                    color: isDark ? const Color(0xFF334155) : AppColors.line,
                  ),
                  _buildAccountTile(
                    icon: Icons.apple_rounded,
                    title: appState.tr('delete_apple_account'),
                    subtitle: 'Revoke Apple token & erase personal data',
                    titleColor: AppColors.error,
                    iconColor: isDark ? Colors.white : Colors.black,
                    isDark: isDark,
                    onTap: () => _confirmDeleteAppleAccount(context),
                  ),
                ] else if (isLoggedIn) ...[
                  Divider(
                    height: 1,
                    color: isDark ? const Color(0xFF334155) : AppColors.line,
                  ),
                  _buildAccountTile(
                    icon: Icons.delete_outline_rounded,
                    title: appState.tr('delete_account'),
                    subtitle: 'Right to erasure under DPDP Act 2023',
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    isDark: isDark,
                    onTap: () => _confirmDeleteAccount(context),
                  ),
                ],

                // Logout Option
                if (isLoggedIn) ...[
                  Divider(
                    height: 1,
                    color: isDark ? const Color(0xFF334155) : AppColors.line,
                  ),
                  _buildAccountTile(
                    icon: Icons.logout_rounded,
                    title: appState.tr('log_out'),
                    subtitle: 'Sign out of current account',
                    titleColor: AppColors.error,
                    iconColor: AppColors.error,
                    isDark: isDark,
                    onTap: () => _confirmLogout(context),
                  ),
                ],

                Divider(
                  height: 1,
                  color: isDark ? const Color(0xFF334155) : AppColors.line,
                ),

                _buildAccountTile(
                  icon: Icons.refresh_rounded,
                  title: 'Reset All Demo Data',
                  subtitle: 'Restore curated seed PGs & enrollments',
                  isDark: isDark,
                  onTap: () async {
                    await appState.resetAllData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'All data reset to curated seed state.',
                          ),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. App Version Display Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : AppColors.line,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.marigold,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PGCity App Version ${appState.appVersion}',
                        style: AppTypography.titleSmall(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      Text(
                        'Build ${appState.appBuildNumber} · Ahmedabad Curated Edition (Android & iOS)',
                        style: AppTypography.monoLabel(
                          color: isDark ? Colors.white60 : AppColors.inkSoft,
                        ).copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAuthProviderBadge(AuthProvider provider) {
    IconData icon;
    String label;
    Color bg;
    Color fg;

    switch (provider) {
      case AuthProvider.apple:
        icon = Icons.apple_rounded;
        label = 'Signed in with Apple ID';
        bg = Colors.black;
        fg = Colors.white;
        break;
      case AuthProvider.google:
        icon = Icons.g_mobiledata_rounded;
        label = 'Signed in with Google';
        bg = const Color(0xFF4285F4);
        fg = Colors.white;
        break;
      case AuthProvider.phonePassword:
        icon = Icons.lock_outline_rounded;
        label = 'Phone & Password';
        bg = AppColors.cream;
        fg = AppColors.navy;
        break;
      case AuthProvider.emailPassword:
        icon = Icons.email_outlined;
        label = 'Email & Password';
        bg = AppColors.cream;
        fg = AppColors.navy;
        break;
      case AuthProvider.phoneOtp:
      default:
        icon = Icons.sms_outlined;
        label = 'Mobile & SMS OTP';
        bg = AppColors.cream;
        fg = AppColors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
    required bool isDark,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: iconColor ?? (isDark ? Colors.white : AppColors.ink),
        size: 20,
      ),
      title: Text(
        title,
        style: AppTypography.titleSmall(
          color: titleColor ?? (isDark ? Colors.white : AppColors.ink),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTypography.bodySmall(
                color: isDark ? Colors.white60 : AppColors.inkSoft,
              ).copyWith(fontSize: 11),
            )
          : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: isDark ? Colors.white38 : AppColors.inkSoft,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  Widget _buildStatusBadge(EnrollmentStatus status) {
    Color bg;
    Color fg;
    switch (status) {
      case EnrollmentStatus.underReview:
        bg = AppColors.marigold;
        fg = AppColors.navy;
        break;
      case EnrollmentStatus.accepted:
        bg = AppColors.teal;
        fg = Colors.white;
        break;
      case EnrollmentStatus.rejected:
      case EnrollmentStatus.cancelled:
        bg = AppColors.error;
        fg = Colors.white;
        break;
      case EnrollmentStatus.submitted:
        bg = AppColors.tealLight;
        fg = AppColors.teal;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: fg,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'JetBrains Mono',
        ),
      ),
    );
  }
}
