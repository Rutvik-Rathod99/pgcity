import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'package:pgcity/presentation/widgets/interactive_pg_map.dart';
import 'package:pgcity/presentation/widgets/pg_preview_card.dart';
import 'package:pgcity/presentation/widgets/city_selector_sheet.dart';
import 'package:pgcity/presentation/widgets/notification_sheet.dart';
import 'package:pgcity/presentation/screens/pg_detail/pg_web_screen.dart';

class HomeScreen extends StatefulWidget {
  final AppState appState;

  const HomeScreen({super.key, required this.appState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.appState.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCitySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CitySelectorSheet(
        currentCity: widget.appState.currentCity,
        onSelectCity: (city) => widget.appState.setCity(city),
      ),
    );
  }

  void _openNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.appSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => NotificationSheet(
        notifications: widget.appState.notifications,
        onMarkAsRead: (id) => widget.appState.markNotificationAsRead(id),
        onMarkAllRead: () => widget.appState.markAllNotificationsAsRead(),
      ),
    );
  }

  void _navigateToPG(PGModel pg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PGWebScreen(pg: pg, appState: widget.appState),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final pgs = state.filteredPGs;
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Top Bar: Brand, Admin Tag, Notifications
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Signature 45 deg Marigold Pin Icon
                      Transform.rotate(
                        angle: -0.785398,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: AppColors.marigold,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PGCity',
                        style: AppTypography.brand(
                          color: isDark ? Colors.white : AppColors.ink,
                        ).copyWith(fontSize: 20),
                      ),
                      if (state.isAdminMode) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'ADMIN OPS',
                            style: AppTypography.monoBadge(
                              color: AppColors.marigold,
                            ).copyWith(fontSize: 8),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      // View Mode Toggle (Map / List)
                      IconButton(
                        onPressed: () => state.toggleViewMode(),
                        icon: Icon(
                          state.isMapView
                              ? Icons.format_list_bulleted_rounded
                              : Icons.map_rounded,
                          color: isDark ? Colors.white : AppColors.ink,
                          size: 22,
                        ),
                        tooltip: state.isMapView
                            ? state.tr('view_list')
                            : state.tr('view_map'),
                      ),
                      // Notification Bell with Badge
                      Stack(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: context.appSurface,
                              shape: BoxShape.circle,
                              border: Border.all(color: context.appBorder),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.notifications_none_rounded,
                                size: 20,
                                color: isDark ? Colors.white : AppColors.ink,
                              ),
                              padding: EdgeInsets.zero,
                              onPressed: _openNotifications,
                            ),
                          ),
                          if (state.unreadNotificationsCount > 0)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.marigold,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${state.unreadNotificationsCount}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. City Selector Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: GestureDetector(
                onTap: _openCitySelector,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: isDark ? Colors.white60 : AppColors.inkSoft,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      state.currentCity,
                      style: AppTypography.bodySmall(
                        color: isDark ? Colors.white60 : AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Change',
                      style: AppTypography.button(
                        color: AppColors.teal,
                      ).copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 3. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: context.appSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.appBorder),
                  boxShadow: const [AppColors.softShadow],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => state.setSearchQuery(val),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: state.tr('search_hint'),
                    hintStyle: AppTypography.bodySmall(
                      color: isDark ? Colors.white38 : AppColors.inkSoft,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.white54 : AppColors.inkSoft,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              state.setSearchQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // 4. Horizontal Scrollable Filter Chips (Screen 1 & PRD 11.4)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip(
                    label: state.tr('filter_all'),
                    isSelected:
                        state.genderFilter == GenderFilter.all &&
                        state.priceFilter == PriceFilter.all,
                    onTap: () => state.clearFilters(),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    label: state.tr('filter_girls'),
                    isSelected: state.genderFilter == GenderFilter.girls,
                    onTap: () => state.setGenderFilter(
                      state.genderFilter == GenderFilter.girls
                          ? GenderFilter.all
                          : GenderFilter.girls,
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    label: state.tr('filter_boys'),
                    isSelected: state.genderFilter == GenderFilter.boys,
                    onTap: () => state.setGenderFilter(
                      state.genderFilter == GenderFilter.boys
                          ? GenderFilter.all
                          : GenderFilter.boys,
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    label: state.tr('filter_under_10k'),
                    isSelected: state.priceFilter == PriceFilter.under10k,
                    onTap: () => state.setPriceFilter(
                      state.priceFilter == PriceFilter.under10k
                          ? PriceFilter.all
                          : PriceFilter.under10k,
                    ),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _buildFilterChip(
                    label: state.tr('filter_above_10k'),
                    isSelected: state.priceFilter == PriceFilter.above10k,
                    onTap: () => state.setPriceFilter(
                      state.priceFilter == PriceFilter.above10k
                          ? PriceFilter.all
                          : PriceFilter.above10k,
                    ),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 5. Main Content: Map or List View
            Expanded(
              child: pgs.isEmpty
                  ? _buildEmptyState(state, isDark)
                  : state.isMapView
                  ? _buildMapView(state, pgs, isDark)
                  : _buildListView(state, pgs),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.marigold : AppColors.navy)
              : context.appSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.marigold : AppColors.navy)
                : context.appBorder,
          ),
          boxShadow: isSelected ? const [AppColors.softShadow] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? AppColors.navy : Colors.white)
                : (isDark ? Colors.white70 : AppColors.inkSoft),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildMapView(AppState state, List<PGModel> pgs, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.appBorder),
        boxShadow: const [AppColors.softShadow],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Canvas Interactive Map
          Positioned.fill(
            child: InteractivePGMap(
              pgs: pgs,
              selectedPG: state.selectedPG,
              onSelectPG: (pg) => state.selectPG(pg),
            ),
          ),

          // Floating PG Preview Card at bottom of map
          if (state.selectedPG != null)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: PGPreviewCard(
                pg: state.selectedPG!,
                isLiked: state.isPGLiked(state.selectedPG!.id),
                onToggleLike: () => state.toggleLike(state.selectedPG!.id),
                onTap: () => _navigateToPG(state.selectedPG!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListView(AppState state, List<PGModel> pgs) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: pgs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pg = pgs[index];
        final isLiked = state.isPGLiked(pg.id);

        return PGPreviewCard(
          pg: pg,
          isLiked: isLiked,
          onToggleLike: () => state.toggleLike(pg.id),
          onTap: () => _navigateToPG(pg),
        );
      },
    );
  }

  Widget _buildEmptyState(AppState state, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.marigold.withAlpha(40),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 32,
                color: AppColors.marigoldDark,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              state.tr('no_pgs_found'),
              style: AppTypography.displaySmall(
                color: isDark ? Colors.white : AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.tr('try_adjusting_filters'),
              style: AppTypography.bodyMedium(
                color: isDark ? Colors.white60 : AppColors.inkSoft,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                state.clearFilters();
              },
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(state.tr('clear_filters')),
            ),
          ],
        ),
      ),
    );
  }
}
