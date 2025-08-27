import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MapCanvasWidget extends StatefulWidget {
  const MapCanvasWidget({super.key});

  @override
  State<MapCanvasWidget> createState() => _MapCanvasWidgetState();
}

class _MapCanvasWidgetState extends State<MapCanvasWidget>
    with TickerProviderStateMixin {
  late final MapController _mapController;
  late AnimationController _carAnimationController;
  late AnimationController _pulseController;
  late Animation<double> _carMovementAnimation;
  late Animation<double> _pulseAnimation;

  // London coordinates with AI-enhanced positioning
  static const LatLng _piccadillyCircus = LatLng(51.5100, -0.1347);
  static const LatLng _towerBridge = LatLng(51.5055, -0.0754);
  static const LatLng _centerLondon = LatLng(51.5074, -0.1278);

  // Dynamic car positions for AI animation
  late List<LatLng> _routePoints;
  int _currentCarPosition = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeAnimations();
    _generateRoutePoints();
  }

  void _initializeAnimations() {
    // Car movement animation
    _carAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Pulse animation for AI markers
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _carMovementAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _carAnimationController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start animations
    _carAnimationController.repeat();
    _pulseController.repeat(reverse: true);

    // Listen to car animation for position updates
    _carAnimationController.addListener(() {
      if (mounted) {
        setState(() {
          _currentCarPosition =
              (_carMovementAnimation.value * (_routePoints.length - 1)).round();
        });
      }
    });
  }

  void _generateRoutePoints() {
    // Generate smooth route points for car animation
    _routePoints = [];
    const int steps = 50;

    for (int i = 0; i <= steps; i++) {
      double t = i / steps;

      // Use Bézier curve for smooth path
      double lat = _lerp(_piccadillyCircus.latitude, _towerBridge.latitude, t);
      double lng = _lerp(
        _piccadillyCircus.longitude,
        _towerBridge.longitude,
        t,
      );

      // Add some curve to make it more realistic
      double curvature = 0.002 * (4 * t * (1 - t)); // Quadratic curve
      lat += curvature;

      _routePoints.add(LatLng(lat, lng));
    }
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  void dispose() {
    _mapController.dispose();
    _carAnimationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryLight.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _centerLondon,
            initialZoom: 13.5,
            minZoom: 10.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            // Enhanced base map tiles
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.rideshare_demo.app',
              maxZoom: 19,
            ),

            // AI-enhanced route polyline with gradient effect
            PolylineLayer(
              polylines: [
                // Main route
                Polyline(
                  points: _routePoints,
                  strokeWidth: 6.0,
                  color: AppTheme.routePrimary,
                  pattern: const StrokePattern.solid(),
                ),
                // Glowing effect
                Polyline(
                  points: _routePoints,
                  strokeWidth: 10.0,
                  color: AppTheme.routePrimary.withValues(alpha: 0.3),
                  pattern: const StrokePattern.solid(),
                ),
                // AI prediction route (alternate)
                Polyline(
                  points: [_piccadillyCircus, _towerBridge],
                  strokeWidth: 4.0,
                  color: AppTheme.routeAlternate.withValues(alpha: 0.6),
                  pattern: const StrokePattern.dotted(),
                ),
              ],
            ),

            // Enhanced location markers with AI branding
            MarkerLayer(
              markers: [
                // Animated start marker
                Marker(
                  point: _piccadillyCircus,
                  child: _buildAnimatedMarker(
                    'Piccadilly Circus',
                    Icons.location_on,
                    AppTheme.primaryLight,
                    isStart: true,
                  ),
                  width: 25.w,
                  height: 12.h,
                ),

                // Animated end marker
                Marker(
                  point: _towerBridge,
                  child: _buildAnimatedMarker(
                    'Tower Bridge',
                    Icons.flag,
                    AppTheme.successLight,
                    isStart: false,
                  ),
                  width: 25.w,
                  height: 12.h,
                ),

                // Animated car marker
                if (_routePoints.isNotEmpty)
                  Marker(
                    point:
                        _routePoints[_currentCarPosition.clamp(
                          0,
                          _routePoints.length - 1,
                        )],
                    child: _buildAnimatedCar(),
                    width: 15.w,
                    height: 15.w,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedMarker(
    String label,
    IconData icon,
    Color color, {
    required bool isStart,
  }) {
    return AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Column(
              children: [
                // AI-enhanced label
                Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.9), color],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        label,
                        style: AppTheme.lightTheme.textTheme.labelSmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: const Duration(milliseconds: 800))
                    .slideY(
                      begin: -0.3,
                      end: 0,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                    ),

                SizedBox(height: 1.h),

                // AI-enhanced marker with pulse effect
                Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [color, color.withValues(alpha: 0.8)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 4,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                ),
              ],
            );
          },
        )
        .animate(delay: Duration(milliseconds: isStart ? 200 : 400))
        .scaleXY(
          begin: 0.5,
          end: 1.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
        );
  }

  Widget _buildAnimatedCar() {
    return AnimatedBuilder(
          animation: _carAnimationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _getCarRotation(),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryLinearGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.2),
                      blurRadius: 3,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            );
          },
        )
        .animate(onPlay: (controller) => controller.repeat())
        .scaleXY(
          begin: 0.9,
          end: 1.1,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeInOut,
        );
  }

  double _getCarRotation() {
    if (_routePoints.length < 2 ||
        _currentCarPosition >= _routePoints.length - 1) {
      return 0;
    }

    final current = _routePoints[_currentCarPosition];
    final next = _routePoints[_currentCarPosition + 1];

    final deltaLat = next.latitude - current.latitude;
    final deltaLng = next.longitude - current.longitude;

    return math.atan2(deltaLng, deltaLat);
  }
}
