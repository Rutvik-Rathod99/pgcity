import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'package:pgcity/presentation/screens/pg_detail/pg_web_screen.dart';

class PGCompareScreen extends StatelessWidget {
  final AppState appState;

  const PGCompareScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final pgs = appState.comparedPGs;

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: context.appBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.ink,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Compare PGs (${pgs.length}/3)',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        actions: [
          if (pgs.isNotEmpty)
            TextButton(
              onPressed: () {
                appState.clearCompare();
                Navigator.pop(context);
              },
              child: Text(
                'Clear All',
                style: AppTypography.button(
                  color: AppColors.error,
                ).copyWith(fontSize: 12),
              ),
            ),
        ],
      ),
      body: pgs.isEmpty
          ? _buildEmptyState(context, isDark)
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Info Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F3934)
                          : AppColors.tealLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.teal.withAlpha(isDark ? 90 : 60),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.compare_arrows_rounded,
                          color: AppColors.teal,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Comparing ${pgs.length} shortlisted accommodations in Ahmedabad.',
                            style: AppTypography.bodySmall(
                              color: isDark
                                  ? const Color(0xFF38BDF8)
                                  : AppColors.teal,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Side-by-side Table Matrix
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(
                        pgs.length == 1
                            ? (MediaQuery.of(context).size.width - 32)
                            : (pgs.length == 2
                                  ? (MediaQuery.of(context).size.width - 32) / 2
                                  : 160.0),
                      ),
                      border: TableBorder.all(
                        color: context.appBorder,
                        borderRadius: BorderRadius.circular(16),
                        width: 1,
                      ),
                      children: [
                        // 1. Header Card Row (Image, Name, Delete)
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildHeaderCell(context, pg, isDark),
                              )
                              .toList(),
                        ),

                        // 2. Monthly Rent Row
                        _buildSectionHeaderRow(
                          'PRICING & DEPOSIT',
                          pgs.length,
                          isDark,
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildDataCell(
                                  label: 'Monthly Rent',
                                  value: CurrencyFormatter.format(
                                    pg.monthlyRent,
                                  ),
                                  isHighlighted: true,
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildDataCell(
                                  label: 'Security Deposit',
                                  value: CurrencyFormatter.format(
                                    pg.securityDeposit,
                                  ),
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),

                        // 3. Accommodation Specs
                        _buildSectionHeaderRow(
                          'ROOM & AMENITIES',
                          pgs.length,
                          isDark,
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildDataCell(
                                  label: 'Sharing Types',
                                  value: pg.sharingType,
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildDataCell(
                                  label: 'Food Plan',
                                  value: pg.foodOption,
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildDataCell(
                                  label: 'Electricity',
                                  value: pg.electricityOption,
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildDataCell(
                                  label: 'Minimum Stay',
                                  value: pg.minimumStay,
                                  isDark: isDark,
                                ),
                              )
                              .toList(),
                        ),

                        // 4. Amenities Checklist
                        _buildSectionHeaderRow(
                          'ESSENTIALS CHECKLIST',
                          pgs.length,
                          isDark,
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildChecklistCell(
                                  'Wi-Fi',
                                  pg.amenities.contains('Wi-Fi'),
                                  isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildChecklistCell(
                                  'Air Conditioning',
                                  pg.amenities.contains('AC'),
                                  isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildChecklistCell(
                                  '24/7 Security & CCTV',
                                  pg.amenities.contains('24/7 security') ||
                                      pg.amenities.contains('CCTV'),
                                  isDark,
                                ),
                              )
                              .toList(),
                        ),
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map(
                                (pg) => _buildChecklistCell(
                                  'Washing Machine',
                                  pg.amenities.contains('Washing machine'),
                                  isDark,
                                ),
                              )
                              .toList(),
                        ),

                        // 5. Direct View Action
                        TableRow(
                          decoration: BoxDecoration(color: context.appSurface),
                          children: pgs
                              .map((pg) => _buildActionCell(context, pg))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.compare_arrows_rounded,
                size: 48,
                color: AppColors.marigold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No PGs Added to Compare',
              style: AppTypography.titleMedium(
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the "Compare" icon on any PG card or details screen to compare up to 3 properties side-by-side.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall(
                color: isDark ? Colors.white60 : AppColors.inkSoft,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Explore PGs'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, PGModel pg, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.marigold.withAlpha(isDark ? 60 : 40),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  pg.type.label.toUpperCase(),
                  style: AppTypography.monoBadge(
                    color: isDark ? AppColors.marigold : AppColors.navy,
                  ).copyWith(fontSize: 8),
                ),
              ),
              GestureDetector(
                onTap: () => appState.toggleCompare(pg.id),
                child: const Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              pg.photos.isNotEmpty ? pg.photos.first : '',
              height: 75,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 75,
                color: AppColors.cream,
                child: const Icon(Icons.apartment_rounded),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pg.name,
            style: AppTypography.titleSmall(
              color: isDark ? Colors.white : AppColors.ink,
            ).copyWith(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            pg.locality,
            style: AppTypography.bodySmall(
              color: isDark ? Colors.white60 : AppColors.inkSoft,
            ).copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  TableRow _buildSectionHeaderRow(String title, int colCount, bool isDark) {
    return TableRow(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
      ),
      children: List.generate(
        colCount,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            i == 0 ? title : '',
            style: AppTypography.monoBadge(
              color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
            ).copyWith(fontSize: 9),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCell({
    required String label,
    required String value,
    bool isHighlighted = false,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.monoLabel(
              color: isDark ? Colors.white38 : AppColors.inkSoft,
            ).copyWith(fontSize: 8),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: isHighlighted
                ? AppTypography.monoPrice(
                    color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                  ).copyWith(fontSize: 13)
                : AppTypography.titleSmall(
                    color: isDark ? Colors.white : AppColors.ink,
                  ).copyWith(fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCell(String feature, bool hasFeature, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Icon(
            hasFeature ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: hasFeature
                ? AppColors.teal
                : (isDark ? Colors.white24 : AppColors.line),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 10,
                fontWeight: hasFeature ? FontWeight.w600 : FontWeight.normal,
                color: hasFeature
                    ? (isDark ? Colors.white : AppColors.ink)
                    : (isDark ? Colors.white38 : AppColors.inkSoft),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, PGModel pg) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PGWebScreen(pg: pg, appState: appState),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        ),
        child: const FittedBox(child: Text('View Details')),
      ),
    );
  }
}
