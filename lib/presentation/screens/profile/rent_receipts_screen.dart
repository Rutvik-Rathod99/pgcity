import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class RentReceiptsScreen extends StatelessWidget {
  final AppState appState;

  const RentReceiptsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final receipts = appState.rentReceipts;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rental Agreement & Receipts',
          style: AppTypography.titleMedium(color: isDark ? Colors.white : AppColors.ink),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
        children: [
          // 1. Digital Rental Agreement Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.appBorder),
              boxShadow: const [AppColors.softShadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withAlpha(40),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.verified_user_rounded, color: AppColors.teal, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active Tenancy Agreement',
                              style: AppTypography.titleSmall(color: isDark ? Colors.white : AppColors.ink),
                            ),
                            Text(
                              'Valid through May 2027 (11-Month Lock-in)',
                              style: AppTypography.bodySmall(color: isDark ? Colors.white60 : AppColors.inkSoft).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(color: context.appBorder),
                const SizedBox(height: 8),

                _buildAgreementRow('Property', 'Sunrise Luxury PG for Girls, Navrangpura', isDark),
                _buildAgreementRow('Monthly Rent', '₹8,500 / month', isDark),
                _buildAgreementRow('Security Deposit', '₹10,000 (Refundable in Escrow)', isDark),
                _buildAgreementRow('Notice Period', '30 Days Mandatory', isDark),
                _buildAgreementRow('Digital Signature', 'Verified by PGCity Operations', isDark),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Downloading digital rental agreement PDF...'),
                          backgroundColor: AppColors.teal,
                        ),
                      );
                    },
                    icon: const Icon(Icons.download_rounded, size: 16),
                    label: const Text('Download Signed Agreement PDF'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Receipts List Header
          Text(
            'Payment & Invoice History',
            style: AppTypography.titleMedium(color: isDark ? Colors.white : AppColors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            'Official tax and rent receipts for HRA tax exemption claims.',
            style: AppTypography.bodySmall(color: isDark ? Colors.white60 : AppColors.inkSoft),
          ),
          const SizedBox(height: 12),

          // Receipts cards
          for (final r in receipts)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: context.appSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.appBorder),
                boxShadow: const [AppColors.softShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.monthYear,
                            style: AppTypography.titleMedium(color: isDark ? Colors.white : AppColors.ink),
                          ),
                          Text(
                            'Invoice: ${r.invoiceId} · ${DateFormat('dd MMM yyyy').format(r.paidDate)}',
                            style: AppTypography.monoLabel(color: isDark ? Colors.white60 : AppColors.inkSoft).copyWith(fontSize: 10),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tealLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'PAID',
                          style: AppTypography.monoBadge(color: AppColors.teal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildInvoiceDetailRow('Base Rent', CurrencyFormatter.format(r.amount), isDark),
                        _buildInvoiceDetailRow('Electricity (AC Units)', CurrencyFormatter.format(r.electricityCharges), isDark),
                        _buildInvoiceDetailRow('Maintenance & Wi-Fi', CurrencyFormatter.format(r.maintenanceCharges), isDark),
                        const Divider(),
                        _buildInvoiceDetailRow('Total Paid', CurrencyFormatter.format(r.totalPaid), isDark, isBold: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ref: ${r.transactionReference}',
                        style: AppTypography.monoBadge(color: isDark ? Colors.white38 : AppColors.inkSoft).copyWith(fontSize: 9),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading rent invoice ${r.invoiceId} for HRA claim.'),
                              backgroundColor: AppColors.teal,
                            ),
                          );
                        },
                        icon: const Icon(Icons.receipt_long_rounded, size: 14),
                        label: const Text('Download Receipt', style: TextStyle(fontSize: 11)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAgreementRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodySmall(color: isDark ? Colors.white60 : AppColors.inkSoft)),
          Text(value, style: AppTypography.titleSmall(color: isDark ? Colors.white : AppColors.ink).copyWith(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildInvoiceDetailRow(String label, String value, bool isDark, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDark ? Colors.white70 : AppColors.ink,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? (isDark ? const Color(0xFF38BDF8) : AppColors.teal) : (isDark ? Colors.white : AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
