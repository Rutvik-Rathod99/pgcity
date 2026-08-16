import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';

class VideoTourScreen extends StatefulWidget {
  final PGModel pg;

  const VideoTourScreen({super.key, required this.pg});

  @override
  State<VideoTourScreen> createState() => _VideoTourScreenState();
}

class _VideoTourScreenState extends State<VideoTourScreen> {
  bool _isPlaying = true;
  double _progress = 0.35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        title: Text(
          'Video Tour',
          style: AppTypography.titleMedium(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Video link copied: https://youtu.be/${widget.pg.youtubeVideoId}'),
                  backgroundColor: AppColors.teal,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Simulation Frame
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    widget.pg.photos.isNotEmpty
                        ? widget.pg.photos.first
                        : 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                  // Play / Pause central button
                  GestureDetector(
                    onTap: () => setState(() => _isPlaying = !_isPlaying),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.marigold,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: AppColors.navy,
                        size: 36,
                      ),
                    ),
                  ),
                  // Live Time & Controls Bar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              trackHeight: 3,
                              activeTrackColor: AppColors.marigold,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.marigold,
                            ),
                            child: Slider(
                              value: _progress,
                              onChanged: (val) => setState(() => _progress = val),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '01:15 / 03:42',
                                style: AppTypography.monoBadge(color: Colors.white70),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'YouTube HD',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.fullscreen_rounded, color: Colors.white, size: 20),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Video Information Panel
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.navy2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'OFFICIAL PG TOUR',
                          style: AppTypography.monoBadge(color: Colors.white).copyWith(fontSize: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Verified by PGCity Ops',
                        style: AppTypography.bodySmall(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.pg.youtubeVideoTitle,
                    style: AppTypography.titleLarge(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.pg.name} · ${widget.pg.locality}, ${widget.pg.city}',
                    style: AppTypography.bodyMedium(color: AppColors.marigold),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: AppColors.lineDark),
                  const SizedBox(height: 14),
                  Text(
                    'What you will see in this video:',
                    style: AppTypography.titleSmall(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('00:00 — Entrance, Reception & 24/7 Biometric Security'),
                  _buildBulletPoint('00:45 — Twin Sharing & Single Air Conditioned Rooms'),
                  _buildBulletPoint('01:30 — Attached Clean Bathrooms & Geyser Fittings'),
                  _buildBulletPoint('02:15 — Dining Hall, Live Kitchen & Weekly Menu Board'),
                  _buildBulletPoint('03:00 — Rooftop Terrace & Laundry Washing Machines'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.play_circle_outline_rounded, color: AppColors.marigold, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
