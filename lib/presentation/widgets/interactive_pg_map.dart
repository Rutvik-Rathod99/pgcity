import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pgcity/core/constants/app_colors.dart';
import 'package:pgcity/core/constants/app_typography.dart';
import 'package:pgcity/data/models/pg_model.dart';
import 'custom_pin_marker.dart';

class InteractivePGMap extends StatefulWidget {
  final List<PGModel> pgs;
  final PGModel? selectedPG;
  final ValueChanged<PGModel> onSelectPG;

  const InteractivePGMap({
    super.key,
    required this.pgs,
    required this.selectedPG,
    required this.onSelectPG,
  });

  @override
  State<InteractivePGMap> createState() => _InteractivePGMapState();
}

class _InteractivePGMapState extends State<InteractivePGMap>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _pulseController;

  // Center coordinate around Navrangpura / University area Ahmedabad
  // Lat: 23.0300, Long: 72.5400
  static const double _centerLat = 23.0300;
  static const double _centerLng = 72.5400;
  static const double _scaleFactor = 7000.0; // Conversion from Lat/Lng to Canvas pixels

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Initial scale and center
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerMapOnSelected();
    });
  }

  @override
  void didUpdateWidget(covariant InteractivePGMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPG != oldWidget.selectedPG && widget.selectedPG != null) {
      _centerMapOnSelected();
    }
  }

  void _centerMapOnSelected() {
    final target = widget.selectedPG;
    if (target != null && mounted) {
      final pos = _latLngToCanvas(target.latitude, target.longitude);
      // Center the interactive viewer matrix on target position
      final matrix = Matrix4.identity()
        ..translateByDouble(-pos.dx + 180, -pos.dy + 200)
        ..scaleByDouble(1.1);
      _transformationController.value = matrix;
    }
  }

  void _recenterOnUser() {
    // Navrangpura center
    final matrix = Matrix4.identity()
      ..translateByDouble(-200.0, -180.0)
      ..scaleByDouble(1.0);
    _transformationController.value = matrix;
  }

  void _zoomIn() {
    final matrix = _transformationController.value.clone();
    matrix.scaleByDouble(1.25);
    _transformationController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformationController.value.clone();
    matrix.scaleByDouble(0.8);
    _transformationController.value = matrix;
  }

  Offset _latLngToCanvas(double lat, double lng) {
    // Map Canvas size: 800 x 800
    final dx = 400 + (lng - _centerLng) * _scaleFactor;
    final dy = 400 - (lat - _centerLat) * _scaleFactor;
    return Offset(dx, dy);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Interactive Canvas Map
        InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.6,
          maxScale: 2.5,
          boundaryMargin: const EdgeInsets.all(300),
          child: SizedBox(
            width: 800,
            height: 800,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Custom Vector Painted City Map
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CityMapPainter(),
                  ),
                ),

                // User Location Live Pulse
                Positioned(
                  left: 390,
                  top: 410,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 32 * _pulseController.value,
                            height: 32 * _pulseController.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.teal.withValues(
                                alpha: 1.0 - _pulseController.value,
                              ),
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.teal,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: const [AppColors.pinShadow],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // PG Pin Markers
                for (final pg in widget.pgs)
                  _buildPinWidget(pg),
              ],
            ),
          ),
        ),

        // Floating Map Controls (Zoom In, Zoom Out, Recenter Location)
        Positioned(
          right: 14,
          top: 14,
          child: Column(
            children: [
              _buildMapFab(
                icon: Icons.my_location_rounded,
                onTap: _recenterOnUser,
                tooltip: 'My Location',
              ),
              const SizedBox(height: 8),
              _buildMapFab(
                icon: Icons.add_rounded,
                onTap: _zoomIn,
                tooltip: 'Zoom In',
              ),
              const SizedBox(height: 6),
              _buildMapFab(
                icon: Icons.remove_rounded,
                onTap: _zoomOut,
                tooltip: 'Zoom Out',
              ),
            ],
          ),
        ),

        // Map Legend / Area indicator
        Positioned(
          left: 14,
          top: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.paper.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.line),
              boxShadow: const [AppColors.softShadow],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.teal,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${widget.pgs.length} PGs in this area',
                  style: AppTypography.monoLabel(color: AppColors.ink).copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinWidget(PGModel pg) {
    final isSelected = widget.selectedPG?.id == pg.id;
    final pos = _latLngToCanvas(pg.latitude, pg.longitude);

    return Positioned(
      left: pos.dx - 45,
      top: pos.dy - 55,
      child: CustomPinMarker(
        pg: pg,
        isSelected: isSelected,
        onTap: () => widget.onSelectPG(pg),
      ),
    );
  }

  Widget _buildMapFab({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Material(
      color: AppColors.paper,
      borderRadius: BorderRadius.circular(12),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Icon(icon, size: 18, color: AppColors.ink),
        ),
      ),
    );
  }
}

/// Custom Vector Canvas Painter for Map Background
class _CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base terrain
    final basePaint = Paint()..color = const Color(0xFFEBE6D6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), basePaint);

    // 2. Parks & Greenery (Vastrapur lake garden, Law garden, Riverfront)
    final parkPaint = Paint()..color = const Color(0xFFD6E8DB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(80, 180, 140, 100), const Radius.circular(20)),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(480, 110, 160, 130), const Radius.circular(24)),
      parkPaint,
    );
    canvas.drawCircle(const Offset(680, 620), 80, parkPaint); // Kankaria lake area

    // 3. Water Body (Sabarmati River & Lakes)
    final waterPaint = Paint()..color = const Color(0xFFC3DFE4);
    // Sabarmati river curve
    final riverPath = Path()
      ..moveTo(620, 0)
      ..cubicTo(600, 200, 560, 450, 580, 800)
      ..lineTo(640, 800)
      ..cubicTo(620, 450, 660, 200, 680, 0)
      ..close();
    canvas.drawPath(riverPath, waterPaint);

    // Vastrapur Lake
    canvas.drawOval(const Rect.fromLTWH(110, 210, 80, 50), waterPaint);

    // Kankaria Lake
    canvas.drawCircle(const Offset(680, 620), 45, waterPaint);

    // 4. Urban Blocks
    final blockPaint = Paint()..color = const Color(0xFFDDD5BE);
    final blocks = [
      const Rect.fromLTWH(40, 40, 90, 80),
      const Rect.fromLTWH(160, 50, 110, 70),
      const Rect.fromLTWH(300, 40, 130, 90),
      const Rect.fromLTWH(50, 310, 120, 90),
      const Rect.fromLTWH(210, 200, 130, 110),
      const Rect.fromLTWH(380, 170, 140, 130),
      const Rect.fromLTWH(220, 340, 140, 110),
      const Rect.fromLTWH(390, 330, 130, 120),
      const Rect.fromLTWH(70, 440, 120, 140),
      const Rect.fromLTWH(230, 480, 150, 120),
      const Rect.fromLTWH(410, 480, 120, 150),
      const Rect.fromLTWH(80, 620, 140, 130),
      const Rect.fromLTWH(250, 630, 130, 130),
      const Rect.fromLTWH(420, 660, 130, 100),
    ];
    for (final b in blocks) {
      canvas.drawRRect(RRect.fromRectAndRadius(b, const Radius.circular(8)), blockPaint);
    }

    // 5. Roads (Major highways & streets)
    final mainRoadPaint = Paint()
      ..color = const Color(0xFFFAF7EE)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final secondaryRoadPaint = Paint()
      ..color = const Color(0xFFF3EDDC)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // SG Highway & 132ft Ring Road
    canvas.drawLine(const Offset(30, 0), const Offset(30, 800), mainRoadPaint);
    canvas.drawLine(const Offset(190, 0), const Offset(190, 800), mainRoadPaint);
    canvas.drawLine(const Offset(370, 0), const Offset(370, 800), mainRoadPaint);
    canvas.drawLine(const Offset(550, 0), const Offset(550, 800), mainRoadPaint);

    // Cross Avenues (Drive In Rd, University Rd, CG Rd)
    canvas.drawLine(const Offset(0, 150), const Offset(800, 150), mainRoadPaint);
    canvas.drawLine(const Offset(0, 320), const Offset(800, 320), mainRoadPaint);
    canvas.drawLine(const Offset(0, 465), const Offset(800, 465), mainRoadPaint);
    canvas.drawLine(const Offset(0, 610), const Offset(800, 610), mainRoadPaint);

    // Secondary streets
    canvas.drawLine(const Offset(0, 240), const Offset(550, 240), secondaryRoadPaint);
    canvas.drawLine(const Offset(0, 390), const Offset(550, 390), secondaryRoadPaint);
    canvas.drawLine(const Offset(0, 540), const Offset(550, 540), secondaryRoadPaint);
    canvas.drawLine(const Offset(280, 150), const Offset(280, 610), secondaryRoadPaint);
    canvas.drawLine(const Offset(460, 150), const Offset(460, 610), secondaryRoadPaint);

    // Metro Line (dashed orange line)
    final metroPaint = Paint()
      ..color = AppColors.marigoldDark
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final metroPath = Path()
      ..moveTo(20, 320)
      ..lineTo(190, 320)
      ..lineTo(370, 465)
      ..lineTo(750, 465);

    // Draw dashed path
    const dashWidth = 8.0;
    const dashSpace = 5.0;
    double distance = 0.0;
    for (final metric in metroPath.computeMetrics()) {
      while (distance < metric.length) {
        final next = math.min(distance + dashWidth, metric.length);
        final segment = metric.extractPath(distance, next);
        canvas.drawPath(segment, metroPaint);
        distance += dashWidth + dashSpace;
      }
    }

    // 6. Landmark Text Labels
    _drawText(canvas, 'Navrangpura', const Offset(380, 270), AppColors.inkSoft);
    _drawText(canvas, 'Satellite', const Offset(120, 270), AppColors.inkSoft);
    _drawText(canvas, 'University Area', const Offset(310, 160), AppColors.inkSoft);
    _drawText(canvas, 'Prahlad Nagar', const Offset(110, 475), AppColors.inkSoft);
    _drawText(canvas, 'Bodakdev', const Offset(115, 110), AppColors.inkSoft);
    _drawText(canvas, 'Maninagar', const Offset(620, 560), AppColors.inkSoft);
    _drawText(canvas, 'Sabarmati River', const Offset(585, 340), const Color(0xFF6B9EA8), rotate: true);
  }

  void _drawText(Canvas canvas, String text, Offset offset, Color color, {bool rotate = false}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    if (rotate) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(1.4);
      tp.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
