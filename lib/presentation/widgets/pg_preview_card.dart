import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';

class PGPreviewCard extends StatelessWidget {
  final PGModel pg;
  final bool isLiked;
  final VoidCallback onToggleLike;
  final bool isCompared;
  final VoidCallback? onToggleCompare;
  final VoidCallback onTap;

  const PGPreviewCard({
    super.key,
    required this.pg,
    required this.isLiked,
    required this.onToggleLike,
    this.isCompared = false,
    this.onToggleCompare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompared ? AppColors.teal : context.appBorder,
            width: isCompared ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withAlpha(80)
                  : const Color.fromRGBO(20, 31, 41, 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail Image with Verified & Featured Badge overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    pg.photos.isNotEmpty
                        ? pg.photos.first
                        : 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=400&q=80',
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.marigold.withAlpha(70),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                if (pg.isVerified)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2),
                          Text(
                            'VERIFIED',
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),

            // Content details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title, Compare & Like Actions
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pg.name,
                          style: AppTypography.titleMedium(
                            color: isDark ? Colors.white : AppColors.ink,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onToggleCompare != null)
                        GestureDetector(
                          onTap: onToggleCompare,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              isCompared
                                  ? Icons.compare_arrows_rounded
                                  : Icons.compare_arrows_outlined,
                              size: 20,
                              color: isCompared
                                  ? AppColors.teal
                                  : (isDark ? Colors.white38 : AppColors.inkSoft),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: onToggleLike,
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            isLiked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: isLiked
                                ? AppColors.likedRed
                                : (isDark ? Colors.white38 : AppColors.inkSoft),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  // PG Type & Distance
                  Text(
                    '${pg.type.label} · ${pg.distanceKm} km away · ${pg.locality}',
                    style: AppTypography.bodySmall(
                      color: isDark ? Colors.white60 : AppColors.inkSoft,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Price and View PG Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: CurrencyFormatter.format(pg.monthlyRent),
                              style: AppTypography.monoPrice(
                                color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                              ).copyWith(fontSize: 14),
                            ),
                            TextSpan(
                              text: '/mo',
                              style: AppTypography.bodySmall(
                                color: isDark ? Colors.white60 : AppColors.inkSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.marigold.withAlpha(isDark ? 50 : 35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View PG',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.marigold : AppColors.marigoldDark,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 10,
                              color: isDark ? AppColors.marigold : AppColors.marigoldDark,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
