import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

import '../../../theme/app_theme.dart';

class RealisticMapWidget extends StatefulWidget {
  final List<LatLng> routePoints;
  final double carProgress;
  final double routeProgress;
  final int tripPhase;
  final Function(MapController) onMapReady;

  const RealisticMapWidget({
    Key? key,
    required this.routePoints,
    required this.carProgress,
    required this.routeProgress,
    required this.tripPhase,
    required this.onMapReady,
  }) : super(key: key);

  @override
  State<RealisticMapWidget> createState() => _RealisticMapWidgetState();
}

class _RealisticMapWidgetState extends State<RealisticMapWidget> {
  late MapController _mapController;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _createMarkers();
    _createPolylines();

    // Notify parent when map is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMapReady(_mapController);
    });
  }

  void _createMarkers() {
    if (widget.routePoints.isEmpty) return;

    _markers = [
      // Pickup marker
      Marker(
        point: widget.routePoints.first,
        width: 40.0,
        height: 40.0,
        child: Icon(Icons.location_on, color: Colors.green, size: 40),
      ),

      // Destination marker
      Marker(
        point: widget.routePoints.last,
        width: 40.0,
        height: 40.0,
        child: Icon(Icons.location_on, color: Colors.red, size: 40),
      ),

      // Car marker (dynamic position)
      Marker(
        point: _getCurrentCarPosition(),
        width: 30.0,
        height: 30.0,
        child: Icon(Icons.directions_car, color: Colors.blue, size: 30),
      ),
    ];
  }

  void _createPolylines() {
    if (widget.routePoints.length < 2) return;

    // Full route (background)
    final fullRoute = Polyline(
        points: widget.routePoints,
        strokeWidth: 6.0,
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3));

    // Completed route (foreground - only if in trip phase)
    List<Polyline> polylines = [fullRoute];

    if (widget.tripPhase >= 2 && widget.carProgress > 0) {
      final completedPoints = _getCompletedRoutePoints();
      if (completedPoints.length >= 2) {
        final completedRoute = Polyline(
            points: completedPoints,
            strokeWidth: 4.0,
            color: AppTheme.lightTheme.colorScheme.primary);
        polylines.add(completedRoute);
      }
    }

    _polylines = polylines;
  }

  LatLng _getCurrentCarPosition() {
    if (widget.routePoints.isEmpty) return widget.routePoints.first;

    final progress = widget.carProgress;
    final totalSegments = widget.routePoints.length - 1;

    if (totalSegments <= 0) return widget.routePoints.first;

    final currentSegment = (progress * totalSegments).floor();
    final segmentProgress = (progress * totalSegments) - currentSegment;

    if (currentSegment >= totalSegments) {
      return widget.routePoints.last;
    }

    final startPoint = widget.routePoints[currentSegment];
    final endPoint = widget.routePoints[currentSegment + 1];

    final lat = startPoint.latitude +
        (endPoint.latitude - startPoint.latitude) * segmentProgress;
    final lng = startPoint.longitude +
        (endPoint.longitude - startPoint.longitude) * segmentProgress;

    return LatLng(lat, lng);
  }

  double _getCarRotation() {
    if (widget.routePoints.length < 2) return 0.0;

    final progress = widget.carProgress;
    final totalSegments = widget.routePoints.length - 1;
    final currentSegment = (progress * totalSegments).floor();

    if (currentSegment >= totalSegments) return 0.0;

    final startPoint = widget.routePoints[currentSegment];
    final endPoint = widget.routePoints[currentSegment + 1];

    final deltaLat = endPoint.latitude - startPoint.latitude;
    final deltaLng = endPoint.longitude - startPoint.longitude;

    return math.atan2(deltaLng, deltaLat);
  }

  List<LatLng> _getCompletedRoutePoints() {
    if (widget.routePoints.isEmpty) return [];

    final progress = widget.carProgress;
    final totalSegments = widget.routePoints.length - 1;
    final completedSegments = (progress * totalSegments).floor();

    if (completedSegments <= 0) return [widget.routePoints.first];

    List<LatLng> completedPoints =
        widget.routePoints.take(completedSegments + 1).toList();

    // Add current car position as the last point
    completedPoints.add(_getCurrentCarPosition());

    return completedPoints;
  }

  @override
  void didUpdateWidget(RealisticMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update markers and polylines when properties change
    if (oldWidget.carProgress != widget.carProgress ||
        oldWidget.routeProgress != widget.routeProgress ||
        oldWidget.tripPhase != widget.tripPhase) {
      _createMarkers();
      _createPolylines();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        mapController: _mapController,
        options: MapOptions(minZoom: 10.0, maxZoom: 18.0),
        children: [
          // OpenStreetMap tiles for realistic map view
          TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.rideshare_demo.app',
              maxNativeZoom: 19,
              retinaMode: MediaQuery.of(context).devicePixelRatio > 1.0),

          // Alternative: Mapbox tiles (requires API key)
          // TileLayer(
          //   urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
          //   additionalOptions: const {
          //     'accessToken': 'your-mapbox-access-token-here',
          //   },
          // ),

          // Polylines layer (route)
          PolylineLayer(polylines: _polylines),

          // Markers layer
          MarkerLayer(markers: _markers),
        ]);
  }
}