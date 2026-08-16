import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'edit_profile_sheet.dart';
import 'privacy_policy_modal.dart';
import 'help_support_modal.dart';
import 'package:pgcity/presentation/screens/admin/admin_dashboard_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  void _openEditProfile(BuildContext context) {
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

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.paper,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete Account?',
          style: AppTypography.titleMedium(color: AppColors.error),
        ),
        content: Text(
          'Under the DPDP Act 2023, this will permanently erase your profile, personal details, unlocked contact history, and enrollment records from our servers. This action cannot be undone.',
          style: AppTypography.bodySmall(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              appState.logoutUser();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account and data permanently erased.'),
                  backgroundColor: AppColors.error,
                ),
              );
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
    final user = appState.currentUser;
    final enrollments = appState.enrollments;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: Text(
          'My Profile',
          style: AppTypography.displaySmall(color: AppColors.ink),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.navy),
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
          // 1. User Header with Initials (Matches Screen 6 in UI spec)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
              boxShadow: const [AppColors.softShadow],
            ),
            child: Row(
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
                      style: AppTypography.displaySmall(color: AppColors.marigold),
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
                              user?.fullName ?? 'Guest User',
                              style: AppTypography.titleMedium(color: AppColors.ink),
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
                        user?.mobileNumber ?? 'No phone saved',
                        style: AppTypography.bodySmall(color: AppColors.inkSoft),
                      ),
                      Text(
                        user?.occupation ?? 'Student / Professional',
                        style: AppTypography.bodySmall(color: AppColors.teal),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _openEditProfile(context),
                  icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.navy),
                  tooltip: 'Edit Profile',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. My Enrollments Section (Matches Screen 6 in UI spec)
          Text(
            'My Enrollments (${enrollments.length})',
            style: AppTypography.titleLarge(color: AppColors.ink),
          ),
          const SizedBox(height: 10),

          if (enrollments.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.assignment_late_outlined, color: AppColors.inkSoft, size: 32),
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
                    color: AppColors.paper,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.line),
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
                                  style: AppTypography.titleMedium(color: AppColors.ink),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Submitted ${DateFormat('dd MMM yyyy').format(enr.submittedAt)} · ${enr.sharingType}',
                                  style: AppTypography.bodySmall(color: AppColors.inkSoft),
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
                            style: AppTypography.monoBadge(color: AppColors.inkSoft)
                                .copyWith(fontSize: 10),
                          ),
                          Text(
                            CurrencyFormatter.format(enr.pgRent),
                            style: AppTypography.monoPrice(color: AppColors.teal)
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      if (enr.adminNote != null && enr.adminNote!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.comment_outlined, size: 14, color: AppColors.inkSoft),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Note: ${enr.adminNote}',
                                  style: AppTypography.bodySmall(color: AppColors.inkSoft),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
          const SizedBox(height: 24),

          // 3. Account Settings List (Matches Screen 6 in UI spec)
          Text(
            'Account & Settings',
            style: AppTypography.titleLarge(color: AppColors.ink),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: AppColors.paper,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              children: [
                _buildAccountTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile Information',
                  onTap: () => _openEditProfile(context),
                ),
                const Divider(height: 1, color: AppColors.line),
                _buildAccountTile(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help, FAQ & WhatsApp Support',
                  onTap: () => _openHelpSupport(context),
                ),
                const Divider(height: 1, color: AppColors.line),
                _buildAccountTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy & DPDP Notice',
                  onTap: () => _openPrivacyPolicy(context),
                ),
                const Divider(height: 1, color: AppColors.line),
                _buildAccountTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Onboarding Portal',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminDashboardScreen(appState: appState),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, color: AppColors.line),
                _buildAccountTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Delete Account (Right to Erasure)',
                  titleColor: AppColors.error,
                  iconColor: AppColors.error,
                  onTap: () => _confirmDeleteAccount(context),
                ),
                const Divider(height: 1, color: AppColors.line),
                _buildAccountTile(
                  icon: Icons.logout_rounded,
                  title: 'Reset All Demo Data',
                  onTap: () async {
                    await appState.resetAllData();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All data reset to curated seed state.'),
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

          // Version note
          Center(
            child: Text(
              'PGCity Mobile v1.0.0 · Ahmedabad Curated Edition',
              style: AppTypography.monoLabel(color: AppColors.inkSoft).copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor ?? AppColors.ink, size: 20),
      title: Text(
        title,
        style: AppTypography.titleSmall(color: titleColor ?? AppColors.ink),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        size: 20,
        color: AppColors.inkSoft,
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
