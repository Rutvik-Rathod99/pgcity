import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'home/home_screen.dart';
import 'liked/liked_pgs_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppState appState;

  const MainNavigationScreen({super.key, required this.appState});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        if (widget.appState.isLoading) {
          return Scaffold(
            backgroundColor: context.appBg,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.marigold),
            ),
          );
        }

        final screens = [
          HomeScreen(appState: widget.appState),
          LikedPGsScreen(appState: widget.appState),
          ProfileScreen(appState: widget.appState),
        ];

        final isDark = context.isDark;

        return Scaffold(
          backgroundColor: context.appBg,
          body: IndexedStack(index: _currentIndex, children: screens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: context.appSurface,
              border: Border(top: BorderSide(color: context.appBorder)),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withAlpha(80)
                      : const Color.fromRGBO(20, 31, 41, 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              MediaQuery.of(context).padding.bottom > 0
                  ? MediaQuery.of(context).padding.bottom
                  : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                  label: widget.appState.tr('nav_home'),
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.favorite_border_rounded,
                  activeIcon: Icons.favorite_rounded,
                  label: widget.appState.tr('nav_liked'),
                  badgeCount: widget.appState.likedPGs.length,
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: widget.appState.tr('nav_profile'),
                  badgeCount: widget.appState.enrollments.length,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int? badgeCount,
  }) {
    final isSelected = _currentIndex == index;
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 24,
                  color: isSelected
                      ? (isDark ? AppColors.marigold : AppColors.navy)
                      : (isDark ? Colors.white54 : AppColors.inkSoft),
                ),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppColors.marigold,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(
                            color: AppColors.navy,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? AppColors.marigold : AppColors.navy)
                    : (isDark ? Colors.white54 : AppColors.inkSoft),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
