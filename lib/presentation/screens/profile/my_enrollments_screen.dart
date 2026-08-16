import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/core/utils/currency_formatter.dart';
import 'package:pgcity/data/models/enrollment_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';
import 'package:pgcity/presentation/screens/pg_detail/pg_web_screen.dart';

class MyEnrollmentsScreen extends StatefulWidget {
  final AppState appState;

  const MyEnrollmentsScreen({super.key, required this.appState});

  @override
  State<MyEnrollmentsScreen> createState() => _MyEnrollmentsScreenState();
}

class _MyEnrollmentsScreenState extends State<MyEnrollmentsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final allEnrollments = widget.appState.enrollments;

    final filtered = allEnrollments.where((e) {
      if (_filter == 'In Review') {
        return e.status == EnrollmentStatus.underReview;
      }
      if (_filter == 'Accepted') {
        return e.status == EnrollmentStatus.accepted;
      }
      if (_filter == 'Rejected') {
        return e.status == EnrollmentStatus.rejected;
      }
      return true;
    }).toList();

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
          '${widget.appState.tr('my_enrollments')} (${allEnrollments.length})',
          style: AppTypography.titleMedium(
            color: isDark ? Colors.white : AppColors.ink,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          if (allEnrollments.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: ['All', 'In Review', 'Accepted', 'Rejected'].map((f) {
                  final isSel = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: isSel,
                      onSelected: (val) {
                        if (val) setState(() => _filter = f);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState(context, isDark, allEnrollments.isEmpty)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final enr = filtered[index];
                      return _buildEnrollmentCard(context, enr, isDark);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentCard(
    BuildContext context,
    EnrollmentModel enr,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.appBorder),
        boxShadow: const [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PG Name & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enr.pgName,
                      style: AppTypography.titleMedium(
                        color: isDark ? Colors.white : AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Submitted on ${DateFormat('dd MMM yyyy, hh:mm a').format(enr.submittedAt)}',
                      style: AppTypography.bodySmall(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : AppColors.inkSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusBadge(enr.status),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: context.appBorder),
          const SizedBox(height: 10),

          // Details Grid
          Row(
            children: [
              Expanded(
                child: _buildDetailTile(
                  'Room Sharing',
                  enr.sharingType,
                  Icons.meeting_room_outlined,
                  isDark,
                ),
              ),
              Expanded(
                child: _buildDetailTile(
                  'Monthly Rent',
                  CurrencyFormatter.format(enr.pgRent),
                  Icons.payments_outlined,
                  isDark,
                  valueColor: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildDetailTile(
                  'Move-in Date',
                  DateFormat('dd MMM yyyy').format(enr.moveInDate),
                  Icons.calendar_today_outlined,
                  isDark,
                ),
              ),
              Expanded(
                child: _buildDetailTile(
                  'Applicant Mobile',
                  enr.applicantPhone,
                  Icons.phone_outlined,
                  isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Application ID: ${enr.id.substring(0, enr.id.length > 12 ? 12 : enr.id.length)}...',
                style: AppTypography.monoLabel(
                  color: isDark ? Colors.white38 : AppColors.inkSoft,
                ).copyWith(fontSize: 10),
              ),
              GestureDetector(
                onTap: () {
                  final pg = widget.appState.allPGs
                      .where((p) => p.id == enr.pgId)
                      .firstOrNull;
                  if (pg != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PGWebScreen(pg: pg, appState: widget.appState),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Viewing application details for ${enr.pgName}',
                        ),
                        backgroundColor: AppColors.teal,
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View PG Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? const Color(0xFF38BDF8)
                            : AppColors.teal,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(
    String label,
    String value,
    IconData icon,
    bool isDark, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 15,
          color: isDark ? Colors.white60 : AppColors.inkSoft,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.inkSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? (isDark ? Colors.white : AppColors.ink),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(EnrollmentStatus status) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case EnrollmentStatus.underReview:
      case EnrollmentStatus.submitted:
        bg = AppColors.marigold.withAlpha(40);
        fg = AppColors.marigoldDark;
        label = status == EnrollmentStatus.submitted
            ? 'Submitted'
            : 'Under Review';
        icon = Icons.hourglass_top_rounded;
        break;
      case EnrollmentStatus.accepted:
        bg = AppColors.teal.withAlpha(40);
        fg = AppColors.teal;
        label = 'Accepted';
        icon = Icons.check_circle_outline_rounded;
        break;
      case EnrollmentStatus.rejected:
        bg = AppColors.error.withAlpha(30);
        fg = AppColors.error;
        label = 'Declined';
        icon = Icons.cancel_outlined;
        break;
      case EnrollmentStatus.cancelled:
        bg = Colors.grey.withAlpha(40);
        fg = Colors.grey;
        label = 'Cancelled';
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    bool isDark,
    bool noEnrollmentsAtAll,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : AppColors.tealLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 36,
                color: isDark ? const Color(0xFF38BDF8) : AppColors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              noEnrollmentsAtAll
                  ? 'No Enrollment Applications Yet'
                  : 'No Applications in this Category',
              style: AppTypography.titleMedium(
                color: isDark ? Colors.white : AppColors.ink,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              noEnrollmentsAtAll
                  ? 'When you apply to a PG using "Enroll Now", your application and manager status will appear here.'
                  : 'Try selecting a different filter above.',
              style: AppTypography.bodySmall(
                color: isDark ? Colors.white60 : AppColors.inkSoft,
              ),
              textAlign: TextAlign.center,
            ),
            if (noEnrollmentsAtAll) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.search_rounded, size: 16),
                label: const Text('Explore PGs'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
