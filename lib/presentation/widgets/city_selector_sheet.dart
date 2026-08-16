import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';

class CitySelectorSheet extends StatelessWidget {
  final String currentCity;
  final ValueChanged<String> onSelectCity;

  const CitySelectorSheet({
    super.key,
    required this.currentCity,
    required this.onSelectCity,
  });

  static const List<Map<String, dynamic>> cities = [
    {
      'name': 'Ahmedabad, Gujarat',
      'localityCount': '150+ Verified PGs',
      'isAvailable': true,
    },
    {
      'name': 'Gandhinagar, Gujarat',
      'localityCount': 'Coming Soon (Phase 2)',
      'isAvailable': false,
    },
    {
      'name': 'Vadodara, Gujarat',
      'localityCount': 'Coming Soon (Phase 2)',
      'isAvailable': false,
    },
    {
      'name': 'Surat, Gujarat',
      'localityCount': 'Coming Soon (Phase 2)',
      'isAvailable': false,
    },
    {
      'name': 'Pune, Maharashtra',
      'localityCount': 'Coming Soon (Phase 3)',
      'isAvailable': false,
    },
    {
      'name': 'Bengaluru, Karnataka',
      'localityCount': 'Coming Soon (Phase 3)',
      'isAvailable': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 18),

          Text(
            'Select Discovery City',
            style: AppTypography.displaySmall(color: AppColors.ink),
          ),
          const SizedBox(height: 4),
          Text(
            'PGCity is currently live across major student & corporate hubs in Ahmedabad.',
            style: AppTypography.bodyMedium(color: AppColors.inkSoft),
          ),
          const SizedBox(height: 18),

          for (final c in cities) ...[
            InkWell(
              onTap: c['isAvailable'] as bool
                  ? () {
                      onSelectCity(c['name'] as String);
                      Navigator.pop(context);
                    }
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: currentCity == c['name']
                      ? AppColors.tealLight
                      : AppColors.paper,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: currentCity == c['name']
                        ? AppColors.teal
                        : AppColors.line,
                    width: currentCity == c['name'] ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city_rounded,
                      size: 20,
                      color: currentCity == c['name']
                          ? AppColors.teal
                          : AppColors.inkSoft,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c['name'] as String,
                            style: AppTypography.titleSmall(
                              color: currentCity == c['name']
                                  ? AppColors.navy
                                  : (c['isAvailable'] as bool ? AppColors.ink : AppColors.inkSoft),
                            ),
                          ),
                          Text(
                            c['localityCount'] as String,
                            style: AppTypography.bodySmall(
                              color: currentCity == c['name']
                                  ? AppColors.teal
                                  : AppColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (currentCity == c['name'])
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.teal,
                        size: 20,
                      )
                    else if (!(c['isAvailable'] as bool))
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.line,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'EXPANDING',
                          style: AppTypography.monoBadge(color: AppColors.inkSoft)
                              .copyWith(fontSize: 8),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
