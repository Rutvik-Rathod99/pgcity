import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'package:pgcity/presentation/widgets/pg_preview_card.dart';
import 'package:pgcity/presentation/screens/pg_detail/pg_web_screen.dart';

class LikedPGsScreen extends StatelessWidget {
  final AppState appState;

  const LikedPGsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final liked = appState.likedPGs;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: Text(
          'Liked Properties',
          style: AppTypography.displaySmall(color: AppColors.ink),
        ),
      ),
      body: liked.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.marigold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 32,
                        color: AppColors.marigoldDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Liked PGs Yet',
                      style: AppTypography.displaySmall(color: AppColors.ink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap the heart icon on any PG card to bookmark it here for quick access.',
                      style: AppTypography.bodyMedium(color: AppColors.inkSoft),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: liked.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pg = liked[index];
                return PGPreviewCard(
                  pg: pg,
                  isLiked: true,
                  onToggleLike: () => appState.toggleLike(pg.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PGWebScreen(pg: pg, appState: appState),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
