import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';

class VirtualTour360Screen extends StatefulWidget {
  final PGModel pg;
  final int initialSceneIndex;

  const VirtualTour360Screen({
    super.key,
    required this.pg,
    this.initialSceneIndex = 0,
  });

  @override
  State<VirtualTour360Screen> createState() => _VirtualTour360ScreenState();
}

class _VirtualTour360ScreenState extends State<VirtualTour360Screen>
    with SingleTickerProviderStateMixin {
  late int _currentSceneIndex;
  double _horizontalOffset = 0.0;
  double _verticalOffset = 0.0;
  final double _zoomScale = 1.0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentSceneIndex = widget.initialSceneIndex.clamp(
      0,
      widget.pg.virtualTourScenes.isNotEmpty
          ? widget.pg.virtualTourScenes.length - 1
          : 0,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _horizontalOffset += details.delta.dx * 0.005;
      _verticalOffset = (_verticalOffset + details.delta.dy * 0.003).clamp(
        -0.4,
        0.4,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scenes = widget.pg.virtualTourScenes;
    if (scenes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('360° Tour')),
        body: const Center(child: Text('No 360° scenes available.')),
      );
    }

    final currentScene = scenes[_currentSceneIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 360 Panoramic Simulated Viewer Canvas
          GestureDetector(
            onPanUpdate: _onPanUpdate,
            onTap: () => setState(() => _showControls = !_showControls),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(_horizontalOffset)
                      ..rotateX(_verticalOffset)
                      ..scaleByDouble(_zoomScale, _zoomScale, 1.0, 1.0),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(currentScene.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Interactive Hot-Spots Overlay
                Positioned(
                  left:
                      MediaQuery.of(context).size.width * 0.35 +
                      (_horizontalOffset * 50),
                  top:
                      MediaQuery.of(context).size.height * 0.5 +
                      (_verticalOffset * 80),
                  child: _buildHotspot(
                    label: 'Study Desk & LAN Port',
                    icon: Icons.desk_rounded,
                  ),
                ),
                Positioned(
                  left:
                      MediaQuery.of(context).size.width * 0.65 +
                      (_horizontalOffset * 50),
                  top:
                      MediaQuery.of(context).size.height * 0.42 +
                      (_verticalOffset * 80),
                  child: _buildHotspot(
                    label: 'Split Air Conditioner',
                    icon: Icons.ac_unit_rounded,
                  ),
                ),
              ],
            ),
          ),

          // 360° Gyro / Direction Indicator
          Positioned(
            right: 20,
            top: 70,
            child: AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.explore_rounded,
                      color: AppColors.marigold,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Drag to rotate 360°',
                      style: AppTypography.monoBadge(
                        color: Colors.white,
                      ).copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Top Header (Back button, Scene Title, Close)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  MediaQuery.of(context).padding.top + 8,
                  16,
                  16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.marigold,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '360° TOUR',
                                  style: AppTypography.monoBadge(
                                    color: AppColors.navy,
                                  ).copyWith(fontSize: 9),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.pg.name,
                                  style: AppTypography.titleSmall(
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentScene.title,
                            style: AppTypography.titleMedium(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Scene Selector Carousel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).padding.bottom + 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentScene.description,
                      style: AppTypography.bodySmall(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                    // Thumbnails list
                    SizedBox(
                      height: 64,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: scenes.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final sc = scenes[index];
                          final isSelected = index == _currentSceneIndex;

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _currentSceneIndex = index),
                            child: Container(
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.marigold
                                      : Colors.white24,
                                  width: isSelected ? 2 : 1,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(sc.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withValues(alpha: 0.45),
                                ),
                                padding: const EdgeInsets.all(6),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  sc.roomType,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.marigold
                                        : Colors.white,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotspot({required String label, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.marigold, width: 1.2),
        boxShadow: const [AppColors.softShadow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.marigold),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}
