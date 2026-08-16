import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';

class HelpSupportModal extends StatelessWidget {
  const HelpSupportModal({super.key});

  Future<void> _openSupportWhatsApp() async {
    final uri = Uri.parse(
      'https://wa.me/919876543210?text=Hello%20PGCity%20Support%2C%20I%20need%20help%20with%20an%20accommodation%20inquiry.',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

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
          'Help & Support',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        children: [
          // WhatsApp Help Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.appBorder),
              boxShadow: const [AppColors.softShadow],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F3934)
                        : AppColors.tealLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.headset_mic_rounded,
                    color: AppColors.teal,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Direct Support Team',
                        style: AppTypography.titleSmall(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Available Mon-Sat 9AM-8PM',
                        style: AppTypography.bodySmall(
                          color: isDark ? Colors.white60 : AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openSupportWhatsApp,
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 14),
                  label: const Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          Text(
            'Frequently Asked Questions',
            style: AppTypography.titleMedium(
              color: isDark ? Colors.white : AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),

          _buildFAQItem(
            'Why is contact unlocking gated by a short ad?',
            'PGCity provides 100% free PG discovery, virtual tours, and verified pricing to students without any subscription fees. Rewarded partner ads keep the platform free while preventing automated web scrapers and telemarketers from spamming property owners.',
            context,
            isDark,
          ),
          _buildFAQItem(
            'What does "Under Review" status mean for my enrollment?',
            'When you submit an enrollment request, the PGCity Operations team reviews your preferred move-in date and room sharing availability with the property manager. You will receive an instant notification when your application is accepted.',
            context,
            isDark,
          ),
          _buildFAQItem(
            'How are PGs verified by PGCity?',
            'Every listing published on PGCity is physically inspected by our ground ops team to verify cleanliness, food hygiene, safety measures, Wi-Fi speed, and accurate photographs.',
            context,
            isDark,
          ),
          _buildFAQItem(
            'Is my personal data safe?',
            'Yes. PGCity adheres strictly to the Digital Personal Data Protection Act 2023. We never sell your personal information or spam your contact number.',
            context,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(
    String question,
    String answer,
    BuildContext context,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.appBorder),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        iconColor: isDark ? Colors.white70 : AppColors.ink,
        collapsedIconColor: isDark ? Colors.white38 : AppColors.inkSoft,
        title: Text(
          question,
          style: AppTypography.titleSmall(
            color: isDark ? Colors.white : AppColors.ink,
          ).copyWith(fontSize: 13),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        children: [
          Text(
            answer,
            style: AppTypography.bodySmall(
              color: isDark ? Colors.white70 : AppColors.inkSoft,
            ),
          ),
        ],
      ),
    );
  }
}
