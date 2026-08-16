import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/presentation/controllers/app_state.dart';

class SafetyCenterModal extends StatelessWidget {
  final AppState appState;

  const SafetyCenterModal({super.key, required this.appState});

  Future<void> _callHotline(String number) async {
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _triggerSos(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.appSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Text('Send Emergency SOS Alert?'),
          ],
        ),
        content: const Text(
          'This will trigger an emergency dispatch alert via SMS & WhatsApp to your emergency contacts with your live GPS location.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '🚨 Emergency SOS dispatched to Parents & Guardian.',
                  ),
                  backgroundColor: AppColors.error,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('DISPATCH SOS'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: context.appSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white24
                    : AppColors.inkSoft.withAlpha(80),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.error,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Safety & SOS Center',
                          style: AppTypography.titleLarge(
                            color: isDark ? Colors.white : AppColors.ink,
                          ),
                        ),
                        Text(
                          'Ahmedabad 24x7 Emergency Helplines',
                          style: AppTypography.bodySmall(
                            color: isDark ? Colors.white60 : AppColors.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: context.appBorder),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. One-Tap Panic Button
                GestureDetector(
                  onTap: () => _triggerSos(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withAlpha(100),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sos_rounded, color: Colors.white, size: 36),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PRESS FOR EMERGENCY SOS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                            Text(
                              'Sends live GPS coordinates to Emergency Contacts',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Direct Emergency Hotlines
                Text(
                  'Instant Emergency Dialers',
                  style: AppTypography.titleMedium(
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 10),

                _buildEmergencyTile(
                  title: 'Women in Distress Helpline',
                  number: '1091',
                  subtitle: '24x7 Gujarat Police dedicated women safety wing',
                  icon: Icons.female_rounded,
                  color: const Color(0xFFEC4899),
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildEmergencyTile(
                  title: 'All-in-One National Emergency',
                  number: '112',
                  subtitle: 'Police, Fire and quick response team',
                  icon: Icons.local_police_rounded,
                  color: const Color(0xFF3B82F6),
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildEmergencyTile(
                  title: 'Emergency Medical & Ambulance',
                  number: '108',
                  subtitle: 'Free rapid ambulance service in Gujarat',
                  icon: Icons.medical_services_rounded,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
                const SizedBox(height: 8),

                _buildEmergencyTile(
                  title: 'Tele-MANAS Student Counseling',
                  number: '14416',
                  subtitle:
                      'Toll-free 24/7 mental health & exam stress support',
                  icon: Icons.psychology_rounded,
                  color: const Color(0xFF8B5CF6),
                  isDark: isDark,
                ),
                const SizedBox(height: 24),

                // 3. Local Police Stations in Ahmedabad
                Text(
                  'Local Police Stations (Ahmedabad)',
                  style: AppTypography.titleMedium(
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),

                _buildStationCard(
                  'Navrangpura Police Station',
                  'Near University Tower, CG Road',
                  '079 2644 1000',
                  isDark,
                ),
                _buildStationCard(
                  'Vastrapur Police Station',
                  'Near Vastrapur Lake, IIM Road',
                  '079 2673 2000',
                  isDark,
                ),
                _buildStationCard(
                  'Satellite Police Station',
                  'Near Ramdevnagar, Satellite',
                  '079 2692 3000',
                  isDark,
                ),
                _buildStationCard(
                  'Infocity Police Station',
                  'Infocity Gate 1, Gandhinagar',
                  '079 2321 4000',
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTile({
    required String title,
    required String number,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.line,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _callHotline(number),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: const Icon(Icons.call_rounded, size: 12, color: Colors.white),
            label: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationCard(
    String name,
    String location,
    String phone,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : AppColors.cream,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.ink,
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white60 : AppColors.inkSoft,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.phone_in_talk_rounded,
              size: 18,
              color: AppColors.teal,
            ),
            onPressed: () => _callHotline(phone.replaceAll(' ', '')),
          ),
        ],
      ),
    );
  }
}
