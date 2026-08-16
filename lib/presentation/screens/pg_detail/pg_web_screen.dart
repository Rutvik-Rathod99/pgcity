import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'virtual_tour_360_screen.dart';
import 'video_tour_screen.dart';
import 'photo_lightbox_screen.dart';
import 'contact_unlock_sheet.dart';
import 'package:pgcity/presentation/screens/enrollment/enrollment_sheet.dart';

class PGWebScreen extends StatelessWidget {
  final PGModel pg;
  final AppState appState;

  const PGWebScreen({super.key, required this.pg, required this.appState});

  void _open360Tour(BuildContext context, {int sceneIndex = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            VirtualTour360Screen(pg: pg, initialSceneIndex: sceneIndex),
      ),
    );
  }

  void _openVideoTour(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VideoTourScreen(pg: pg)),
    );
  }

  void _openPhotoGallery(BuildContext context, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PhotoLightboxScreen(
          photos: pg.photos,
          initialIndex: initialIndex,
          title: pg.name,
        ),
      ),
    );
  }

  void _openContactUnlock(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ContactUnlockSheet(pg: pg, appState: appState),
    );
  }

  void _openEnrollment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EnrollmentSheet(pg: pg, appState: appState),
    );
  }

  void _sharePG(BuildContext context) {
    final link = 'https://pgcity.app/pg/${pg.id}';
    final isDark = context.isDark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Share PG Deep Link',
          style: AppTypography.displaySmall(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share this dedicated PG Web Screen with your friends or parents:',
              style: AppTypography.bodySmall(),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.line),
              ),
              child: SelectableText(
                link,
                style: AppTypography.monoBadge(
                  color: AppColors.teal,
                ).copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deep link copied: $link'),
                  backgroundColor: AppColors.teal,
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded, size: 14),
            label: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(BuildContext context) async {
    final query = '${pg.latitude},${pg.longitude}';
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigating to: ${pg.address}'),
            backgroundColor: AppColors.teal,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLiked = appState.isPGLiked(pg.id);
    final isUnlocked = appState.isPGUnlocked(pg.id);
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.appBg,
      body: Stack(
        children: [
          // Scrollable 14-Section Dedicated Mini-Website Body
          CustomScrollView(
            slivers: [
              // 1. Hero Header Sliver App Bar
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () => _sharePG(context),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isLiked ? AppColors.likedRed : Colors.white,
                        size: 20,
                      ),
                      onPressed: () => appState.toggleLike(pg.id),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Header Photo
                      Image.network(
                        pg.photos.isNotEmpty
                            ? pg.photos.first
                            : 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80',
                        fit: BoxFit.cover,
                      ),
                      // Gradient Shade
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withAlpha(80),
                              AppColors.navy.withAlpha(240),
                            ],
                          ),
                        ),
                      ),
                      // Title & Badges Overlay
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.marigold,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    pg.type.label,
                                    style: AppTypography.monoBadge(
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (pg.isVerified)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.teal,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'VERIFIED PG',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              pg.name,
                              style: AppTypography.displayMedium(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${pg.locality}, ${pg.city} · ${CurrencyFormatter.format(pg.monthlyRent)}/month · ${pg.availability.label}',
                              style: AppTypography.bodySmall(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mini-Website Page Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. 360° / 3D Virtual Tour Card (PRD Section 12.3)
                      GestureDetector(
                        onTap: () => _open360Tour(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : AppColors.navy,
                            borderRadius: BorderRadius.circular(16),
                            border: isDark ? Border.all(color: context.appBorder) : null,
                            boxShadow: const [AppColors.softShadow],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -10,
                                bottom: -10,
                                child: Icon(
                                  Icons.view_in_ar_rounded,
                                  size: 80,
                                  color: Colors.white.withAlpha(20),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.marigold,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'INTERACTIVE 360°',
                                          style: AppTypography.monoBadge(
                                            color: AppColors.navy,
                                          ).copyWith(fontSize: 9),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    appState.tr('virtual_tour'),
                                    style: AppTypography.displaySmall(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Inspect bedroom, attached bath & common kitchen with 3D gyroscopic panoramic view.',
                                    style: AppTypography.bodySmall(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. Take a Video Tour (YouTube Vlog) (PRD Section 12.4)
                      GestureDetector(
                        onTap: () => _openVideoTour(context),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(bottom: 16),
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
                                  color: isDark ? const Color(0xFF0F3934) : AppColors.tealLight,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: AppColors.teal,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Take a Video Tour',
                                      style: AppTypography.titleSmall(
                                        color: isDark ? Colors.white : AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      pg.youtubeVideoTitle,
                                      style: AppTypography.bodySmall(
                                        color: isDark ? Colors.white60 : AppColors.inkSoft,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                                color: isDark ? Colors.white60 : AppColors.inkSoft,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 4. Quick Details Grid (PRD Section 12.5)
                      Text(
                        'Quick details',
                        style: AppTypography.titleLarge(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 2.4,
                        children: [
                          _buildDetailBox(
                            context,
                            appState.tr('monthly_rent'),
                            CurrencyFormatter.format(pg.monthlyRent),
                            isDark,
                          ),
                          _buildDetailBox(
                            context,
                            appState.tr('security_deposit'),
                            CurrencyFormatter.format(pg.securityDeposit),
                            isDark,
                          ),
                          _buildDetailBox(
                            context,
                            appState.tr('sharing_options'),
                            pg.sharingType,
                            isDark,
                          ),
                          _buildDetailBox(
                            context,
                            'Minimum Stay',
                            pg.minimumStay,
                            isDark,
                          ),
                          _buildDetailBox(
                            context,
                            appState.tr('food_kitchen'),
                            pg.foodOption,
                            isDark,
                          ),
                          _buildDetailBox(
                            context,
                            'Electricity',
                            pg.electricityOption,
                            isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // 5. About Description (PRD Section 12.6)
                      Text(
                        'About this PG',
                        style: AppTypography.titleLarge(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pg.description,
                        style: AppTypography.bodyLarge(
                          color: isDark ? Colors.white70 : AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 6. Amenities (PRD Section 12.7)
                      Text(
                        appState.tr('amenities'),
                        style: AppTypography.titleLarge(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: pg.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: context.appBorder),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getAmenityIcon(amenity),
                                  size: 15,
                                  color: AppColors.teal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  amenity,
                                  style: AppTypography.titleSmall(
                                    color: isDark ? Colors.white : AppColors.ink,
                                  ).copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // 7. PG Rules (PRD Section 12.8)
                      Text(
                        appState.tr('house_rules'),
                        style: AppTypography.titleLarge(
                          color: isDark ? Colors.white : AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.appSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.appBorder),
                        ),
                        child: Column(
                          children: pg.rules.map((rule) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.shield_outlined,
                                    size: 16,
                                    color: AppColors.marigoldDark,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      rule,
                                      style: AppTypography.bodyMedium(
                                        color: isDark ? Colors.white : AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 8. Location & Nearby Landmarks (PRD Section 12.9)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Location',
                            style: AppTypography.titleLarge(
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => _openDirections(context),
                            icon: const Icon(
                              Icons.navigation_rounded,
                              size: 14,
                              color: AppColors.teal,
                            ),
                            label: Text(
                              'Directions',
                              style: AppTypography.button(
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pg.address,
                        style: AppTypography.bodyMedium(
                          color: isDark ? Colors.white60 : AppColors.inkSoft,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Mini Location Card with Landmarks
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.appSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.appBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.tr('near_landmarks'),
                              style: AppTypography.monoLabel(
                                color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            for (final l in pg.nearbyLandmarks)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 3,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.place_outlined,
                                            size: 14,
                                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              l.name,
                                              style: AppTypography.titleSmall(
                                                color: isDark ? Colors.white : AppColors.ink,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l.distance,
                                      style: AppTypography.monoPrice(
                                        color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                                      ).copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 9. Photos Gallery (PRD Section 12.10)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Photos (${pg.photos.length})',
                            style: AppTypography.titleLarge(
                              color: isDark ? Colors.white : AppColors.ink,
                            ),
                          ),
                          TextButton(
                            onPressed: () => _openPhotoGallery(context, 0),
                            child: Text(
                              'View all',
                              style: AppTypography.button(
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: pg.photos.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _openPhotoGallery(context, index),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  pg.photos[index],
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 10. Likes Counter
                      GestureDetector(
                        onTap: () => appState.toggleLike(pg.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: context.appSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: context.appBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isLiked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: isLiked
                                    ? AppColors.likedRed
                                    : (isDark ? Colors.white60 : AppColors.inkSoft),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${pg.likesCount} seekers liked this property',
                                style: AppTypography.bodySmall(
                                  color: isDark ? Colors.white60 : AppColors.inkSoft,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 12. Sticky Bottom Action Bar (View Contact & Enroll Now)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                10,
                16,
                MediaQuery.of(context).padding.bottom + 10,
              ),
              decoration: BoxDecoration(
                color: context.appSurface,
                border: Border(top: BorderSide(color: context.appBorder)),
                boxShadow: const [AppColors.cardShadow],
              ),
              child: Row(
                children: [
                  // View Contact Button
                  Expanded(
                    flex: 1,
                    child: OutlinedButton.icon(
                      onPressed: () => _openContactUnlock(context),
                      icon: Icon(
                        isUnlocked
                            ? Icons.phone_enabled_rounded
                            : Icons.phone_rounded,
                        size: 16,
                        color: isUnlocked
                            ? AppColors.teal
                            : (isDark ? AppColors.marigold : AppColors.navy),
                      ),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isUnlocked
                              ? appState.tr('call_now')
                              : appState.tr('contact_owner'),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 8,
                        ),
                        foregroundColor: isUnlocked
                            ? AppColors.teal
                            : (isDark ? AppColors.marigold : AppColors.navy),
                        side: BorderSide(
                          color: isUnlocked
                              ? AppColors.teal
                              : (isDark ? AppColors.marigold : AppColors.navy),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Enroll Now Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () => _openEnrollment(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 8,
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(appState.tr('enroll_now')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailBox(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.appBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTypography.monoLabel(
              color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
            ).copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTypography.titleSmall(
              color: isDark ? Colors.white : AppColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  IconData _getAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wi-fi') || lower.contains('wifi')) {
      return Icons.wifi_rounded;
    }
    if (lower.contains('food') || lower.contains('meal')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('ac') || lower.contains('air')) {
      return Icons.ac_unit_rounded;
    }
    if (lower.contains('backup') || lower.contains('power')) {
      return Icons.bolt_rounded;
    }
    if (lower.contains('security') || lower.contains('guard')) {
      return Icons.shield_rounded;
    }
    if (lower.contains('parking')) {
      return Icons.local_parking_rounded;
    }
    if (lower.contains('washing') || lower.contains('laundry')) {
      return Icons.local_laundry_service_rounded;
    }
    if (lower.contains('cctv')) {
      return Icons.videocam_rounded;
    }
    if (lower.contains('study') || lower.contains('table')) {
      return Icons.desk_rounded;
    }
    if (lower.contains('water') || lower.contains('geyser')) {
      return Icons.water_drop_rounded;
    }
    if (lower.contains('refrigerator') || lower.contains('fridge')) {
      return Icons.kitchen_rounded;
    }
    if (lower.contains('common') || lower.contains('lounge')) {
      return Icons.weekend_rounded;
    }
    if (lower.contains('bath')) {
      return Icons.bathtub_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }
}
