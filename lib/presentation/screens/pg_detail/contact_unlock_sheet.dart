import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class ContactUnlockSheet extends StatefulWidget {
  final PGModel pg;
  final AppState appState;

  const ContactUnlockSheet({
    super.key,
    required this.pg,
    required this.appState,
  });

  @override
  State<ContactUnlockSheet> createState() => _ContactUnlockSheetState();
}

class _ContactUnlockSheetState extends State<ContactUnlockSheet> {
  bool _isWatchingAd = false;
  int _adSecondsLeft = 4;
  Timer? _timer;
  late bool _isUnlocked;

  @override
  void initState() {
    super.initState();
    _isUnlocked = widget.appState.isPGUnlocked(widget.pg.id);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRewardedAd() {
    setState(() {
      _isWatchingAd = true;
      _adSecondsLeft = 4;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_adSecondsLeft > 1) {
        setState(() => _adSecondsLeft--);
      } else {
        timer.cancel();
        setState(() {
          _isWatchingAd = false;
          _isUnlocked = true;
        });
        widget.appState.unlockPGContact(widget.pg.id);
      }
    });
  }

  Future<void> _makeCall(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(' ', '');
    final uri = Uri.parse('tel:$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dialer: Calling $phoneNumber'),
            backgroundColor: AppColors.teal,
          ),
        );
      }
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse(
      'https://wa.me/$cleaned?text=Hello%2C%20I%20am%20interested%20in%20${Uri.encodeComponent(widget.pg.name)}%20via%20PGCity.',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('WhatsApp message opened for $phoneNumber'),
            backgroundColor: AppColors.teal,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),

          // Icon Banner
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: AppColors.tealLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: AppColors.teal,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Unlock ${widget.pg.name}\'s Number',
            style: AppTypography.displaySmall(color: AppColors.ink),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            _isUnlocked
                ? 'Verified contact revealed. You can now call or WhatsApp the property manager directly.'
                : 'Watch a short rewarded ad to reveal the contact number, completely free of charge.',
            style: AppTypography.bodyMedium(color: AppColors.inkSoft),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // If currently watching ad
          if (_isWatchingAd) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      color: AppColors.marigold,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Playing Sponsored Partner Ad...',
                    style: AppTypography.titleSmall(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contact unlocks in 00:0$_adSecondsLeft',
                    style: AppTypography.monoBadge(
                      color: AppColors.marigold,
                    ).copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ] else if (!_isUnlocked) ...[
            // Watch Ad CTA Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startRewardedAd,
                icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                label: const Text('Watch Ad to Unlock Contact'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ads help keep PGCity free for all students & professionals.',
              style: AppTypography.bodySmall(color: AppColors.inkSoft),
              textAlign: TextAlign.center,
            ),
          ],

          // If unlocked or after ad completion (matches Screen 3)
          if (_isUnlocked) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.tealLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.teal, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: AppColors.teal,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'UNLOCKED CONTACT',
                            style: AppTypography.monoBadge(
                              color: AppColors.teal,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'SAVED',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.pg.contactNumber,
                        style: AppTypography.monoPrice(
                          color: AppColors.navy,
                        ).copyWith(fontSize: 17),
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _makeCall(widget.pg.contactNumber),
                            icon: const Icon(Icons.call_rounded, size: 14),
                            label: const Text('Call'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () =>
                                _openWhatsApp(widget.pg.contactNumber),
                            icon: const Icon(
                              Icons.chat_bubble_rounded,
                              size: 14,
                            ),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.teal,
                              side: const BorderSide(color: AppColors.teal),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
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
          ],
        ],
      ),
    );
  }
}
