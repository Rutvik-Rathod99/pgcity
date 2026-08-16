import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';

class CustomPinMarker extends StatelessWidget {
  final PGModel pg;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomPinMarker({
    super.key,
    required this.pg,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Price & Name Tag on Selected / Hover
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.navy : AppColors.paper,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.marigold : AppColors.line,
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CurrencyFormatter.format(pg.monthlyRent),
                  style: AppTypography.monoPrice(
                    color: isSelected ? AppColors.marigold : AppColors.teal,
                  ).copyWith(fontSize: 11),
                ),
                const SizedBox(width: 4),
                Text(
                  '· ${pg.name}',
                  style:
                      (isSelected
                              ? AppTypography.monoBadge(color: Colors.white)
                              : AppTypography.monoBadge(color: AppColors.ink))
                          .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
          // 45° Rotated Signature Pin Marker (matches PRD .brand .pin & UI Mockup)
          Stack(
            alignment: Alignment.center,
            children: [
              // Pulse ring if selected
              if (isSelected)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.marigold.withValues(alpha: 0.25),
                  ),
                ),
              // Pin Shape (rotated -45 deg rounded rect)
              Transform.rotate(
                angle: -0.785398, // -45 deg in radians
                child: Container(
                  width: isSelected ? 24 : 18,
                  height: isSelected ? 24 : 18,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.navy : AppColors.marigold,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.zero,
                    ),
                    border: isSelected
                        ? Border.all(color: AppColors.marigold, width: 2.5)
                        : Border.all(color: Colors.white, width: 1.5),
                    boxShadow: const [AppColors.pinShadow],
                  ),
                ),
              ),
              // Inner Dot
              Container(
                width: isSelected ? 6 : 4,
                height: isSelected ? 6 : 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.marigold : AppColors.navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
