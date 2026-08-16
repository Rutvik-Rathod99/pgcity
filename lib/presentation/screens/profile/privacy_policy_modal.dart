import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';

class PrivacyPolicyModal extends StatelessWidget {
  const PrivacyPolicyModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
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
        title: Text(
          'Privacy & DPDP Compliance',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F3934) : AppColors.tealLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teal),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.security_rounded,
                  color: AppColors.teal,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'PGCity complies with the Digital Personal Data Protection Act, 2023 (DPDP Act).',
                    style: AppTypography.bodySmall(
                      color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          Text(
            '1. Notice & Data We Collect',
            style: AppTypography.titleMedium(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'We only collect personal information necessary to facilitate accommodation discovery and verified enrollment: Full Name, Verified Mobile Number, Email Address, Age, Gender, and Preferred Move-in Date.',
            style: AppTypography.bodyMedium(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            '2. Why We Collect Your Data',
            style: AppTypography.titleMedium(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your data is utilized exclusively for:\n• Displaying personalized PG accommodation options.\n• Transmitting verified enrollment leads to property managers.\n• Authenticating your identity via secure 6-digit OTP.\n• Sending real-time notifications regarding application acceptance or rejection.',
            style: AppTypography.bodyMedium(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            '3. Protection of Contact Numbers',
            style: AppTypography.titleMedium(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Property owner contact numbers and applicant personal details are never exposed in public unauthenticated APIs. Contact numbers are revealed solely through authenticated rewarded ad completion or formal enrollment submission.',
            style: AppTypography.bodyMedium(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            '4. Consent Withdrawal & Right to Erasure',
            style: AppTypography.titleMedium(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'In accordance with the DPDP Act 2023, you have full control over your personal data. You may withdraw consent or permanently erase your account and enrollment history at any time using the "Delete Account" option in your Profile settings.',
            style: AppTypography.bodyMedium(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('I Understand'),
            ),
          ),
        ],
      ),
    );
  }
}
