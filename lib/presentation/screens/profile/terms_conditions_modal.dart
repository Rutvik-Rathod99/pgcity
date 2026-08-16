import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';

class TermsConditionsModal extends StatelessWidget {
  const TermsConditionsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.cream,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.cream,
        elevation: 0,
        title: Text(
          'Terms and Conditions',
          style: AppTypography.displaySmall(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.ink,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
        children: [
          // Header Card
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
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.gavel_rounded,
                    color: AppColors.marigold,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PGCity Terms of Service',
                        style: AppTypography.titleMedium(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Effective: August 2026 · Ahmedabad, Gujarat',
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
          const SizedBox(height: 20),

          _buildClauseSection(
            number: '1',
            title: 'Nature of Discovery Platform',
            content:
                'PGCity operates as a curated digital discovery platform for students and working professionals seeking Paying Guest (PG) and co-living accommodations across Ahmedabad (including Navrangpura, Satellite, Vastrapur, Bodakdev, SG Highway, Gandhinagar, and university hubs). PGCity does not own, manage, or operate individual PG properties.',
            isDark: isDark,
          ),

          _buildClauseSection(
            number: '2',
            title: '100% Physical Verification Disclaimer',
            content:
                'While PGCity field executives conduct rigorous on-ground physical inspections to verify photos, room sharing types, security measures, and listed amenities (Wi-Fi, AC, RO Water, CCTV), real-time availability and meal quality are subject to direct confirmation with the property owner.',
            isDark: isDark,
          ),

          _buildClauseSection(
            number: '3',
            title: 'Zero Brokerage & Contact Unlocking',
            content:
                'PGCity provides 100% zero-brokerage contact unlocking for genuine applicants. Users may directly connect with verified landlords via Phone and WhatsApp. PGCity does not charge brokerage commissions on finalized tenancies.',
            isDark: isDark,
          ),

          _buildClauseSection(
            number: '4',
            title: 'Security Deposits & Rental Agreements',
            content:
                'All security deposit terms, refund guidelines, notice periods (standard 30 days in Ahmedabad), and monthly rent payment schedules must be formalized directly between the tenant and property owner through a standard PG agreement.',
            isDark: isDark,
          ),

          _buildClauseSection(
            number: '5',
            title: 'House Rules & Code of Conduct',
            content:
                'Tenants agree to strictly abide by individual PG guidelines including curfew timings (where applicable), visitor policies, non-smoking rules, and noise regulations in residential housing societies across Ahmedabad.',
            isDark: isDark,
          ),

          _buildClauseSection(
            number: '6',
            title: 'Data Privacy & Right to Erasure (DPDP Act 2023)',
            content:
                'PGCity complies with the Digital Personal Data Protection Act 2023 and Apple App Store Review Guideline 5.1.1(v). You have the right to request immediate and permanent erasure of your personal data, saved enrollments, and unlocked contact history through the "Delete Account" option in your Profile at any time.',
            isDark: isDark,
          ),

          _buildClauseSection(
            number: '7',
            title: 'Governing Law & Jurisdiction',
            content:
                'These terms and conditions are governed by the laws of India. Any disputes arising in connection with the platform shall be subject to the exclusive jurisdiction of the competent courts in Ahmedabad, Gujarat.',
            isDark: isDark,
          ),

          const SizedBox(height: 20),

          // Accept button / Footer info
          Center(
            child: Text(
              'PGCity Ahmedabad · Application Version 1.0.0 (Build 100)',
              style: AppTypography.monoLabel(
                color: isDark ? Colors.white38 : AppColors.inkSoft,
              ).copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClauseSection({
    required String number,
    required String title,
    required String content,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: AppColors.marigold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleMedium(
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTypography.bodyMedium(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
