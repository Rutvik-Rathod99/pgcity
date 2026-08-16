import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'admin_pg_editor_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AppState appState;

  const AdminDashboardScreen({super.key, required this.appState});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAddPG() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminPGEditorScreen(appState: widget.appState),
      ),
    );
  }

  void _openEditPG(PGModel pg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminPGEditorScreen(pg: pg, appState: widget.appState),
      ),
    );
  }

  void _confirmDeletePG(PGModel pg) {
    final isDark = context.isDark;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appSurface,
        title: Text(
          'Delete ${pg.name}?',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        content: Text(
          'This property will be permanently removed from PGCity.',
          style: TextStyle(color: isDark ? Colors.white70 : AppColors.inkSoft),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.appState.adminDeletePG(pg.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${pg.name} deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateLeadStatus(EnrollmentModel lead, EnrollmentStatus newStatus) {
    final noteController = TextEditingController();
    final isDark = context.isDark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Update Lead to ${newStatus.label}',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Applicant: ${lead.applicantName}\nProperty: ${lead.pgName}\nSharing: ${lead.sharingType}',
              style: AppTypography.bodySmall(
                color: isDark ? Colors.white70 : AppColors.inkSoft,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              style: TextStyle(color: isDark ? Colors.white : AppColors.ink),
              decoration: const InputDecoration(
                hintText: 'Add an optional note or confirmation code',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.appState.adminUpdateEnrollmentStatus(
                lead.id,
                newStatus,
                note: noteController.text.trim(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lead status updated to ${newStatus.label}'),
                  backgroundColor: AppColors.teal,
                ),
              );
            },
            child: const Text('Confirm Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.appState;
    final allPGs = state.allPGs;
    final enrollments = state.enrollments;
    final isDark = context.isDark;

    // Metrics calculations
    final totalViews = allPGs.fold<int>(0, (sum, pg) => sum + pg.viewsCount);
    final totalUnlocks = allPGs.fold<int>(
      0,
      (sum, pg) => sum + pg.contactUnlocksCount,
    );
    final totalLikes = allPGs.fold<int>(0, (sum, pg) => sum + pg.likesCount);

    return Scaffold(
      backgroundColor: context.appBg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.navy,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(
              Icons.admin_panel_settings_rounded,
              color: AppColors.marigold,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'PGCity Admin Console',
              style: AppTypography.titleMedium(color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle_rounded,
              color: AppColors.marigold,
              size: 24,
            ),
            tooltip: 'Onboard New PG',
            onPressed: _openAddPG,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.marigold,
          labelColor: AppColors.marigold,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'Properties (${allPGs.length})'),
            Tab(text: 'Enrollment Leads (${enrollments.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // KPI Metric Bar (PRD Section 20.1)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            color: isDark ? const Color(0xFF1E293B) : AppColors.navy2,
            child: Row(
              children: [
                Expanded(child: _buildKpiItem('Total PGs', '${allPGs.length}')),
                Expanded(child: _buildKpiItem('Total Views', '$totalViews')),
                Expanded(
                  child: _buildKpiItem('Contact Unlocks', '$totalUnlocks'),
                ),
                Expanded(child: _buildKpiItem('Total Likes', '$totalLikes')),
              ],
            ),
          ),

          // Tabs Body
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: PGs Management
                _buildPGsList(allPGs, isDark),

                // Tab 2: Leads Management
                _buildLeadsList(enrollments, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTypography.displaySmall(
              color: AppColors.marigold,
            ).copyWith(fontSize: 16),
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTypography.monoLabel(
              color: Colors.white70,
            ).copyWith(fontSize: 9),
          ),
        ),
      ],
    );
  }

  Widget _buildPGsList(List<PGModel> pgs, bool isDark) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: pgs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pg = pgs[index];
        return Container(
          padding: const EdgeInsets.all(14),
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
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      pg.photos.isNotEmpty ? pg.photos.first : '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 60,
                        height: 60,
                        color: isDark
                            ? const Color(0xFF334155)
                            : AppColors.cream,
                        child: const Icon(Icons.apartment_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                pg.name,
                                style: AppTypography.titleMedium(
                                  color: isDark ? Colors.white : AppColors.ink,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (pg.isVerified)
                              const Icon(
                                Icons.verified_rounded,
                                size: 16,
                                color: AppColors.teal,
                              ),
                          ],
                        ),
                        Text(
                          '${pg.type.label} · ${pg.locality}',
                          style: AppTypography.bodySmall(
                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    pg.verificationStatus ==
                                        PGVerificationStatus.published
                                    ? (isDark
                                          ? const Color(0xFF0F3934)
                                          : AppColors.tealLight)
                                    : (isDark
                                          ? const Color(0xFF422006)
                                          : AppColors.warningLight),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                pg.verificationStatus.label.toUpperCase(),
                                style: AppTypography.monoBadge(
                                  color:
                                      pg.verificationStatus ==
                                          PGVerificationStatus.published
                                      ? AppColors.teal
                                      : AppColors.warning,
                                ).copyWith(fontSize: 8),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(pg.monthlyRent),
                              style: AppTypography.monoPrice(
                                color: isDark
                                    ? const Color(0xFF38BDF8)
                                    : AppColors.teal,
                              ).copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(color: context.appBorder),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '👁 ${pg.viewsCount} · 📞 ${pg.contactUnlocksCount} · 📝 ${pg.enrollmentsCount} leads',
                      style: AppTypography.monoBadge(
                        color: isDark ? Colors.white60 : AppColors.inkSoft,
                      ).copyWith(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: isDark ? Colors.white : AppColors.navy,
                    ),
                    tooltip: 'Edit Listing',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _openEditPG(pg),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      size: 18,
                      color: AppColors.error,
                    ),
                    tooltip: 'Delete Listing',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _confirmDeletePG(pg),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeadsList(List<EnrollmentModel> leads, bool isDark) {
    if (leads.isEmpty) {
      return Center(
        child: Text(
          'No enrollment leads received yet.',
          style: AppTypography.bodyMedium(
            color: isDark ? Colors.white60 : AppColors.inkSoft,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: leads.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final lead = leads[index];
        return Container(
          padding: const EdgeInsets.all(16),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.applicantName,
                          style: AppTypography.titleMedium(
                            color: isDark ? Colors.white : AppColors.ink,
                          ),
                        ),
                        Text(
                          '${lead.applicantPhone} · ${lead.applicantEmail}',
                          style: AppTypography.bodySmall(
                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusBg(lead.status, isDark),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      lead.status.label,
                      style: AppTypography.monoBadge(
                        color: _getStatusFg(lead.status),
                      ),
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
                    _buildLeadDetailRow('Property', lead.pgName, isDark),
                    _buildLeadDetailRow(
                      'Sharing Type',
                      lead.sharingType,
                      isDark,
                    ),
                    _buildLeadDetailRow(
                      'Move-in Date',
                      DateFormat('dd MMM yyyy').format(lead.moveInDate),
                      isDark,
                    ),
                    _buildLeadDetailRow('Occupation', lead.occupation, isDark),
                    if (lead.message.isNotEmpty)
                      _buildLeadDetailRow('Message', lead.message, isDark),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Action Buttons: Accept / Reject
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        _updateLeadStatus(lead, EnrollmentStatus.rejected),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Reject Lead'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        _updateLeadStatus(lead, EnrollmentStatus.accepted),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Accept Lead'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeadDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall(
              color: isDark ? Colors.white60 : AppColors.inkSoft,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTypography.titleSmall(
                color: isDark ? Colors.white : AppColors.ink,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBg(EnrollmentStatus status, bool isDark) {
    switch (status) {
      case EnrollmentStatus.underReview:
        return AppColors.marigold;
      case EnrollmentStatus.accepted:
        return AppColors.teal;
      case EnrollmentStatus.rejected:
      case EnrollmentStatus.cancelled:
        return AppColors.error;
      case EnrollmentStatus.submitted:
        return isDark ? const Color(0xFF0F3934) : AppColors.tealLight;
    }
  }

  Color _getStatusFg(EnrollmentStatus status) {
    switch (status) {
      case EnrollmentStatus.underReview:
        return AppColors.navy;
      case EnrollmentStatus.accepted:
      case EnrollmentStatus.rejected:
      case EnrollmentStatus.cancelled:
        return Colors.white;
      case EnrollmentStatus.submitted:
        return AppColors.teal;
    }
  }
}
