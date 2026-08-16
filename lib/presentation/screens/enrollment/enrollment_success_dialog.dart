import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';

class EnrollmentSuccessDialog extends StatelessWidget {
  final PGModel pg;
  final String applicantName;
  final DateTime moveInDate;
  final String sharingType;

  const EnrollmentSuccessDialog({
    super.key,
    required this.pg,
    required this.applicantName,
    required this.moveInDate,
    required this.sharingType,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: AppColors.tealLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.teal,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Enrollment Request Sent!',
              style: AppTypography.displaySmall(color: AppColors.ink),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Your application has been received by PGCity Ops and forwarded to property management.',
              style: AppTypography.bodyMedium(color: AppColors.inkSoft),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Summary Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  _buildRow('Property', pg.name),
                  const Divider(color: AppColors.line, height: 16),
                  _buildRow('Applicant', applicantName),
                  const Divider(color: AppColors.line, height: 16),
                  _buildRow('Move-in Date', DateFormat('dd MMM yyyy').format(moveInDate)),
                  const Divider(color: AppColors.line, height: 16),
                  _buildRow('Sharing', sharingType),
                  const Divider(color: AppColors.line, height: 16),
                  _buildRow('Current Status', 'Submitted (Under Review)', isStatus: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Return to discover / profile
                },
                child: const Text('Back to Discovery'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall(color: AppColors.inkSoft),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.marigold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: AppTypography.monoBadge(color: AppColors.marigoldDark),
            ),
          )
        else
          Text(
            value,
            style: AppTypography.titleSmall(color: AppColors.ink),
          ),
      ],
    );
  }
}
