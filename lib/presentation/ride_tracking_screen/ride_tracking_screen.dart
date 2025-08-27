import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/driver_info_sheet.dart';
import './widgets/map_controls.dart';
import './widgets/ride_status_card.dart';

class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _carMovementController;
  late AnimationController _routeAnimationController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _carMovementAnimation;
  late Animation<double> _routeDrawAnimation;

  // Google Maps specific variables
  GoogleMapController? _mapController;
  late CameraPosition _initialCameraPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Marker? _carMarker;
  bool _isMapReady = false;

  String _currentStatus = 'Driver Arriving';
  bool _isDriverInfoExpanded = false;
  int _currentTabIndex = 0;

  // Enhanced timer variables
  Timer? _countdownTimer;
  Timer? _statusUpdateTimer;
  Timer? _progressUpdateTimer;
  Timer? _carUpdateTimer;
  int _countdownSeconds = 180;
  String _estimatedTime = '3 min';
  double _currentZoom = 15.0;
  double _tripProgress = 0.0;

  // Enhanced route simulation data with more realistic London coordinates
  final List<LatLng> _routePoints = [
    const LatLng(51.5099, -0.1342), // Piccadilly Circus (pickup)
    const LatLng(51.5094, -0.1320), // Regent Street
    const LatLng(51.5085, -0.1285), // Oxford Circus
    const LatLng(51.5074, -0.1278), // Bond Street Station
    const LatLng(51.5155, -0.1426), // Marble Arch
    const LatLng(51.5138, -0.1530), // Hyde Park Corner
    const LatLng(51.5014, -0.1419), // Victoria Station
    const LatLng(51.4994, -0.1248), // Westminster
    const LatLng(51.5007, -0.1246), // Westminster Bridge
    const LatLng(51.5045, -0.0865), // London Bridge
    const LatLng(51.5055, -0.0754), // Tower Bridge (destination)
  ];

  final List<String> _routeNames = [
    'Piccadilly Circus',
    'Regent Street',
    'Oxford Circus',
    'Bond Street Station',
    'Marble Arch',
    'Hyde Park Corner',
    'Victoria Station',
    'Westminster',
    'Westminster Bridge',
    'London Bridge',
    'Tower Bridge',
  ];

  // Enhanced status phases with more realistic timing and details
  final List<Map<String, dynamic>> _statusPhases = [
    {
      'status': 'Driver Arriving',
      'duration': 180,
      'description': 'Your driver is on the way to pick you up',
      'progress': 0.0,
    },
    {
      'status': 'Driver Here',
      'duration': 30,
      'description': 'Your driver has arrived at the pickup location',
      'progress': 0.0,
    },
    {
      'status': 'On Trip',
      'duration': 420,
      'description': 'Heading to your destination',
      'progress': 0.0,
    },
    {
      'status': 'Arrived',
      'duration': 0,
      'description': 'You have arrived at your destination',
      'progress': 1.0,
    },
  ];

  int _currentPhaseIndex = 0;
  double _carRotation = 0.0;
  bool _isCarMoving = false;

  // Enhanced driver data with more details
  final Map<String, dynamic> _driverData = {
    'name': 'James Wilson',
    'rating': '4.9',
    'ratingsCount': '2,847',
    'vehicle': 'Toyota Prius Hybrid',
    'plateNumber': 'LN18 ABC',
    'color': 'Silver',
    'avatar':
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
    'phone': '+44 7700 900123',
    'yearsExperience': '5',
  };

  // Trip details
  final Map<String, dynamic> _tripDetails = {
    'from': 'Piccadilly Circus, London',
    'to': 'Tower Bridge, London',
    'distance': '3.2 miles',
    'estimatedDuration': '15 min',
    'fare': '£12.50',
  };

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = CameraPosition(
      target: _routePoints.first,
      zoom: 15.0,
    );
    _initializeAnimations();
    _createInitialMarkers();
    _createRoute();
    _startRideSimulation();
  }

  void _initializeAnimations() {
    // Pulse animation for various elements
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Car movement along route
    _carMovementController = AnimationController(
      duration: const Duration(minutes: 8),
      vsync: this,
    );
    _carMovementAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _carMovementController, curve: Curves.linear),
    );

    // Route drawing animation
    _routeAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _routeDrawAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _routeAnimationController, curve: Curves.easeInOut),
    );

    // Status change animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _slideController.forward();
    _routeAnimationController.forward();

    // Listen to car movement animation to update car position
    _carMovementAnimation.addListener(() {
      _updateCarPosition();
    });
  }

  void _createInitialMarkers() {
    // Pickup marker
    final pickupMarker = Marker(
      markerId: const MarkerId('pickup'),
      position: _routePoints.first,
      infoWindow: InfoWindow(
        title: 'Pickup Location',
        snippet: _routeNames.first,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    // Destination marker
    final destinationMarker = Marker(
      markerId: const MarkerId('destination'),
      position: _routePoints.last,
      infoWindow: InfoWindow(
        title: 'Destination',
        snippet: _routeNames.last,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    // Car marker (initial position)
    _carMarker = Marker(
      markerId: const MarkerId('car'),
      position: _routePoints.first,
      infoWindow: InfoWindow(
        title: 'James Wilson',
        snippet: '${_driverData['vehicle']} - ${_driverData['plateNumber']}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      rotation: _carRotation,
    );

    setState(() {
      _markers.addAll([pickupMarker, destinationMarker, _carMarker!]);
    });
  }

  void _createRoute() {
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: _routePoints,
      color: AppTheme.lightTheme.colorScheme.primary,
      width: 5,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
    );

    setState(() {
      _polylines.add(polyline);
    });
  }

  void _updateCarPosition() {
    if (_routePoints.isEmpty || _carMarker == null) return;

    final progress = _carMovementAnimation.value;
    final currentPosition = _getCurrentPosition(progress);

    // Calculate rotation for realistic car movement
    final rotation = _calculateCarRotation(progress);

    final updatedCarMarker = _carMarker!.copyWith(
      positionParam: currentPosition,
      rotationParam: rotation,
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'car');
      _markers.add(updatedCarMarker);
      _carMarker = updatedCarMarker;
      _carRotation = rotation;
    });

    // Update camera to follow the car smoothly
    if (_isMapReady && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(currentPosition),
      );
    }
  }

  LatLng _getCurrentPosition(double progress) {
    if (_routePoints.isEmpty) return _routePoints.first;

    final totalSegments = _routePoints.length - 1;
    final currentSegment = (progress * totalSegments).floor();
    final segmentProgress = (progress * totalSegments) - currentSegment;

    if (currentSegment >= totalSegments) {
      return _routePoints.last;
    }

    final startPoint = _routePoints[currentSegment];
    final endPoint = _routePoints[currentSegment + 1];

    final lat = startPoint.latitude +
        (endPoint.latitude - startPoint.latitude) * segmentProgress;
    final lng = startPoint.longitude +
        (endPoint.longitude - startPoint.longitude) * segmentProgress;

    return LatLng(lat, lng);
  }

  double _calculateCarRotation(double progress) {
    if (_routePoints.length < 2) return 0.0;

    final totalSegments = _routePoints.length - 1;
    final currentSegment = (progress * totalSegments).floor();

    if (currentSegment >= totalSegments) return _carRotation;

    final startPoint = _routePoints[currentSegment];
    final endPoint = _routePoints[currentSegment + 1];

    final deltaLat = endPoint.latitude - startPoint.latitude;
    final deltaLng = endPoint.longitude - startPoint.longitude;

    return math.atan2(deltaLng, deltaLat) * 180 / math.pi;
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {
      _isMapReady = true;
    });

    // Set map bounds to show the entire route
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            _routePoints.map((p) => p.latitude).reduce(math.min),
            _routePoints.map((p) => p.longitude).reduce(math.min),
          ),
          northeast: LatLng(
            _routePoints.map((p) => p.latitude).reduce(math.max),
            _routePoints.map((p) => p.longitude).reduce(math.max),
          ),
        ),
        100.0,
      ),
    );
  }

  void _startRideSimulation() {
    _pulseController.repeat(reverse: true);
    _startProgressUpdateTimer();
    _startCountdownTimer();
    _startStatusUpdateTimer();
  }

  void _startProgressUpdateTimer() {
    _progressUpdateTimer?.cancel();
    _progressUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && _currentPhaseIndex == 2) {
        // During trip phase
        setState(() {
          _tripProgress = _carMovementAnimation.value;
        });
      }
    });
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdownSeconds > 0) {
            _countdownSeconds--;
            _estimatedTime = _formatTime(_countdownSeconds);
          }
        });
      }
    });
  }

  void _startStatusUpdateTimer() {
    _statusUpdateTimer?.cancel();

    // Phase timing based on current phase
    final currentPhase = _statusPhases[_currentPhaseIndex];
    final phaseDuration = currentPhase['duration'] as int;

    if (phaseDuration > 0) {
      _statusUpdateTimer = Timer(Duration(seconds: phaseDuration), () {
        if (mounted) {
          _updateToNextPhase();
        }
      });
    }
  }

  void _updateToNextPhase() {
    if (_currentPhaseIndex < _statusPhases.length - 1) {
      _currentPhaseIndex++;
      final newPhase = _statusPhases[_currentPhaseIndex];

      setState(() {
        _currentStatus = newPhase['status'] as String;
        _countdownSeconds = newPhase['duration'] as int;
        _estimatedTime = _formatTime(_countdownSeconds);
      });

      // Start car movement animation during trip phase
      if (_currentPhaseIndex == 2) {
        _carMovementController.forward();
      }

      // Trigger haptic feedback and animations
      HapticFeedback.mediumImpact();
      _slideController.reset();
      _slideController.forward();

      // Continue to next phase
      _startStatusUpdateTimer();
    } else {
      // Trip completed - navigate to summary after delay
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/trip-summary-screen');
        }
      });
    }
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return 'Arriving now';

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return remainingSeconds > 0
          ? '$minutes min $remainingSeconds sec'
          : '$minutes min';
    } else {
      return '${remainingSeconds} sec';
    }
  }

  void _centerOnUserLocation() {
    if (_mapController != null && _carMarker != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _carMarker!.position,
            zoom: 16.0,
          ),
        ),
      );
    }
    HapticFeedback.selectionClick();
  }

  void _zoomIn() {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.zoomIn());
    }
    HapticFeedback.lightImpact();
  }

  void _zoomOut() {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.zoomOut());
    }
    HapticFeedback.lightImpact();
  }

  void _toggleDriverInfo() {
    setState(() {
      _isDriverInfoExpanded = !_isDriverInfoExpanded;
    });
    HapticFeedback.selectionClick();
  }

  void _showCancelDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Cancel Ride?',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel this ride? You may be charged a cancellation fee.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Keep Ride',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home-screen');
              },
              child: Text(
                'Cancel Ride',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFDC2626),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _carMovementController.dispose();
    _routeAnimationController.dispose();
    _statusUpdateTimer?.cancel();
    _countdownTimer?.cancel();
    _progressUpdateTimer?.cancel();
    _carUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Real Google Maps integration
            Positioned.fill(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: _initialCameraPosition,
                markers: _markers,
                polylines: _polylines,
                mapType: MapType.normal,
                compassEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                buildingsEnabled: true,
                trafficEnabled: true,
                style: '''
                [
                  {
                    "featureType": "poi",
                    "elementType": "labels",
                    "stylers": [
                      {
                        "visibility": "simplified"
                      }
                    ]
                  }
                ]
                ''',
              ),
            ),

            // Map controls with better positioning
            Positioned(
              right: 4.w,
              top: 22.h,
              child: MapControls(
                onCenterRoute: _centerOnUserLocation,
                onZoomIn: _zoomIn,
                onZoomOut: _zoomOut,
              ),
            ),

            // Enhanced ride status card with better animations
            Positioned(
              top: 4.h,
              left: 4.w,
              right: 4.w,
              child: SlideTransition(
                position: _slideAnimation,
                child: RideStatusCard(
                  status: _currentStatus,
                  estimatedTime: _estimatedTime,
                  progress: _currentPhaseIndex == 2 ? _tripProgress : null,
                  description: _statusPhases[_currentPhaseIndex]['description']
                      as String,
                ),
              ),
            ),

            // Enhanced driver info sheet with more details
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: DriverInfoSheet(
                  driverData: _driverData,
                  tripDetails: _tripDetails,
                  isExpanded: _isDriverInfoExpanded,
                  onToggle: _toggleDriverInfo,
                  onCancelRide: _showCancelDialog,
                ),
              ),
            ),

            // Trip progress indicator (only during trip)
            if (_currentPhaseIndex == 2)
              Positioned(
                top: 16.h,
                left: 4.w,
                right: 4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.shadowColor
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Trip Progress',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${(_tripProgress * 100).toInt()}%',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _tripProgress,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Real map loading indicator
            if (!_isMapReady)
              Positioned.fill(
                child: Container(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar:
          GlobalBottomNavigation(currentIndex: _currentTabIndex),
    );
  }
}
