import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';

class RentCalculatorModal extends StatefulWidget {
  final PGModel pg;

  const RentCalculatorModal({super.key, required this.pg});

  @override
  State<RentCalculatorModal> createState() => _RentCalculatorModalState();
}

class _RentCalculatorModalState extends State<RentCalculatorModal> {
  int _selectedSharing = 2; // 1, 2, or 3 sharing
  double _electricityUnits = 75; // units/month
  final double _unitRate = 8.5; // ₹8.5 per unit
  bool _includeLaundry = true;
  final double _maintenanceFee = 350;

  double get _baseRent {
    if (_selectedSharing == 1) return widget.pg.monthlyRent * 1.4;
    if (_selectedSharing == 3) return widget.pg.monthlyRent * 0.85;
    return widget.pg.monthlyRent;
  }

  double get _electricityCost =>
      (_electricityUnits * _unitRate) / _selectedSharing;
  double get _laundryCost => _includeLaundry ? 450 : 0;
  double get _totalMonthlyPerPerson =>
      _baseRent +
      _electricityCost +
      _laundryCost +
      (_maintenanceFee / _selectedSharing);

  double get _depositPerPerson =>
      widget.pg.securityDeposit *
      (_selectedSharing == 1 ? 1.3 : (_selectedSharing == 3 ? 0.85 : 1.0));

  double get _upfrontMoveInCost => _totalMonthlyPerPerson + _depositPerPerson;

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
                    'True Rent & Living Calculator',
                    style: AppTypography.titleMedium(
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  Text(
                    'Estimate exact monthly outflow & move-in costs',
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
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: [
                // Highlight Total Monthly Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F3934)
                        : AppColors.tealLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.teal.withAlpha(isDark ? 100 : 75),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'TOTAL ESTIMATED MONTHLY OUTFLOW',
                        style: AppTypography.monoBadge(
                          color: isDark
                              ? const Color(0xFF38BDF8)
                              : AppColors.teal,
                        ).copyWith(fontSize: 10),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${CurrencyFormatter.format(_totalMonthlyPerPerson)} / person',
                        style: AppTypography.monoPrice(
                          color: isDark ? Colors.white : AppColors.teal,
                        ).copyWith(fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Includes Rent + AC Electricity Split + Laundry + Maintenance',
                        style: AppTypography.bodySmall(
                          color: isDark ? Colors.white70 : AppColors.inkSoft,
                        ).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Sharing Selection
                Text(
                  '1. Select Room Sharing Type',
                  style: AppTypography.titleSmall(
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [1, 2, 3].map((s) {
                    final isSel = _selectedSharing == s;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Center(child: Text('$s Sharing')),
                          selected: isSel,
                          onSelected: (_) =>
                              setState(() => _selectedSharing = s),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // 2. Estimated Electricity AC Usage
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '2. Estimated AC & Room Units',
                      style: AppTypography.titleSmall(
                        color: isDark ? Colors.white : AppColors.ink,
                      ),
                    ),
                    Text(
                      '${_electricityUnits.toInt()} Units (${CurrencyFormatter.format(_electricityCost)}/person)',
                      style: AppTypography.monoPrice(
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : AppColors.teal,
                      ).copyWith(fontSize: 12),
                    ),
                  ],
                ),
                Slider(
                  value: _electricityUnits,
                  min: 20,
                  max: 200,
                  divisions: 18,
                  activeColor: AppColors.teal,
                  onChanged: (val) => setState(() => _electricityUnits = val),
                ),
                const SizedBox(height: 8),

                // 3. Laundry & Housekeeping Service
                SwitchListTile(
                  title: Text(
                    'Doorstep Laundry & Ironing (+₹450/mo)',
                    style: AppTypography.bodyMedium(
                      color: isDark ? Colors.white : AppColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    'Twice-a-week wash & iron service',
                    style: AppTypography.bodySmall(
                      color: isDark ? Colors.white60 : AppColors.inkSoft,
                    ),
                  ),
                  value: _includeLaundry,
                  activeTrackColor: AppColors.teal,
                  contentPadding: EdgeInsets.zero,
                  onChanged: (v) => setState(() => _includeLaundry = v),
                ),
                const SizedBox(height: 12),

                // 4. Move-in Upfront Breakdown
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.appBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upfront Move-In Cost Breakdown',
                        style: AppTypography.titleSmall(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRow(
                        '1st Month Rent & Utilities',
                        CurrencyFormatter.format(_totalMonthlyPerPerson),
                        isDark,
                      ),
                      _buildRow(
                        'Refundable Security Deposit',
                        CurrencyFormatter.format(_depositPerPerson),
                        isDark,
                      ),
                      _buildRow(
                        'PGCity Booking Token (Deducted)',
                        '₹1,000',
                        isDark,
                      ),
                      const Divider(),
                      _buildRow(
                        'Total Upfront Cash Needed',
                        CurrencyFormatter.format(_upfrontMoveInCost),
                        isDark,
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Close Calculator'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
              color: isDark ? Colors.white70 : AppColors.ink,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: isBold
                  ? (isDark ? const Color(0xFF38BDF8) : AppColors.teal)
                  : (isDark ? Colors.white : AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
