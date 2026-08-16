import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/notification_model.dart';

class NotificationSheet extends StatelessWidget {
  final List<NotificationModel> notifications;
  final ValueChanged<String> onMarkAsRead;
  final VoidCallback onMarkAllRead;

  const NotificationSheet({
    super.key,
    required this.notifications,
    required this.onMarkAsRead,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: AppTypography.displaySmall(color: AppColors.ink),
              ),
              if (notifications.any((n) => !n.isRead))
                TextButton(
                  onPressed: onMarkAllRead,
                  child: Text(
                    'Mark all as read',
                    style: AppTypography.button(
                      color: AppColors.teal,
                    ).copyWith(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          if (notifications.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      size: 40,
                      color: AppColors.inkSoft,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No notifications yet',
                      style: AppTypography.titleSmall(color: AppColors.inkSoft),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: notifications.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return InkWell(
                    onTap: () => onMarkAsRead(notif.id),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: notif.isRead
                            ? AppColors.paper
                            : AppColors.tealLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: notif.isRead ? AppColors.line : AppColors.teal,
                          width: notif.isRead ? 1 : 1.2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: notif.isRead
                                  ? AppColors.cream
                                  : AppColors.teal,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconForType(notif.type),
                              size: 16,
                              color: notif.isRead
                                  ? AppColors.ink
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notif.title,
                                  style: AppTypography.titleSmall(
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  notif.message,
                                  style: AppTypography.bodySmall(
                                    color: AppColors.inkSoft,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimeAgo(notif.createdAt),
                                  style: AppTypography.monoLabel(
                                    color: AppColors.inkSoft,
                                  ).copyWith(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                          if (!notif.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.marigold,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.enrollmentSubmitted:
        return Icons.send_rounded;
      case NotificationType.enrollmentAccepted:
        return Icons.check_circle_outline_rounded;
      case NotificationType.enrollmentRejected:
        return Icons.cancel_outlined;
      case NotificationType.availabilityAlert:
        return Icons.notifications_active_rounded;
      case NotificationType.system:
        return Icons.campaign_rounded;
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
