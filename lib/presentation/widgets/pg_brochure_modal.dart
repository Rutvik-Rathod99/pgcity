import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/services/pg_share_service.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';

class PGBrochureModal extends StatelessWidget {
  final PGModel pg;

  const PGBrochureModal({super.key, required this.pg});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.appBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parent Share & Brochure',
                    style: AppTypography.titleMedium(
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  Text(
                    'Formatted property card with verified specs',
                    style: AppTypography.bodySmall(
                      color: isDark ? Colors.white60 : AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visual Brochure Card
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.appBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Header on Brochure
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Transform.rotate(
                              angle: -0.785398,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: const BoxDecoration(
                                  color: AppColors.marigold,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                    bottomRight: Radius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'PGCity Verified Listing',
                              style: AppTypography.monoBadge(
                                color: isDark ? AppColors.marigold : AppColors.navy,
                              ).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                        if (pg.isVerified)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.teal,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '100% INSPECTED',
                              style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Property Photo & Title
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        pg.photos.isNotEmpty ? pg.photos.first : '',
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          height: 140,
                          color: AppColors.marigold.withAlpha(40),
                          child: const Icon(Icons.apartment_rounded, size: 36),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      pg.name,
                      style: AppTypography.displaySmall(
                        color: isDark ? Colors.white : AppColors.ink,
                      ).copyWith(fontSize: 18),
                    ),
                    Text(
                      '${pg.address}, ${pg.locality}, Ahmedabad',
                      style: AppTypography.bodySmall(
                        color: isDark ? Colors.white70 : AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pricing Grid
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: context.appBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Monthly Rent', style: AppTypography.monoLabel(color: isDark ? Colors.white38 : AppColors.inkSoft).copyWith(fontSize: 9)),
                                Text(
                                  '${CurrencyFormatter.format(pg.monthlyRent)}/mo',
                                  style: AppTypography.monoPrice(color: isDark ? const Color(0xFF38BDF8) : AppColors.teal).copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: context.appBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Security Deposit', style: AppTypography.monoLabel(color: isDark ? Colors.white38 : AppColors.inkSoft).copyWith(fontSize: 9)),
                                Text(
                                  CurrencyFormatter.format(pg.securityDeposit),
                                  style: AppTypography.titleSmall(color: isDark ? Colors.white : AppColors.ink).copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Specs List
                    _buildSpecRow('Room Sharing', pg.sharingType, isDark),
                    _buildSpecRow('Food Included', pg.foodOption, isDark),
                    _buildSpecRow('Electricity', pg.electricityOption, isDark),
                    _buildSpecRow('Lock-in / Minimum Stay', pg.minimumStay, isDark),
                    _buildSpecRow('Verified Contact', pg.contactNumber, isDark),
                    const SizedBox(height: 14),

                    // QR Code Simulation for 360 Tour
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: context.appBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF334155) : AppColors.cream,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.qr_code_2_rounded, size: 36, color: AppColors.navy),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '360° Virtual Tour & Location',
                                  style: AppTypography.titleSmall(
                                    color: isDark ? Colors.white : AppColors.ink,
                                  ).copyWith(fontSize: 12),
                                ),
                                Text(
                                  'Scan QR or click link in WhatsApp message to inspect rooms virtually.',
                                  style: AppTypography.bodySmall(
                                    color: isDark ? Colors.white60 : AppColors.inkSoft,
                                  ).copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Share Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final shareText = PGShareService.generateParentShareText(pg);
                    await PGShareService.copyToClipboard(shareText);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('WhatsApp message copied to clipboard! Ready to paste & send.'),
                          backgroundColor: Color(0xFF25D366),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.share_rounded, size: 16),
                  label: const FittedBox(child: Text('Share on WhatsApp')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall(color: isDark ? Colors.white60 : AppColors.inkSoft)),
          Text(value, style: AppTypography.titleSmall(color: isDark ? Colors.white : AppColors.ink)),
        ],
      ),
    );
  }
}
