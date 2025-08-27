import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/bottom_action_buttons.dart';
import './widgets/driver_arrival_info.dart';
import './widgets/driver_contact_buttons.dart';
import './widgets/driver_profile_header.dart';
import './widgets/safety_features_section.dart';
import './widgets/trip_details_info.dart';
import './widgets/vehicle_tracking_map.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({Key? key}) : super(key: key);

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isTrackingEnabled = true;
  int _currentTabIndex = 0; // Home tab as this is accessed from booking flow

  int _estimatedArrival = 5; // minutes
  bool _isDriverVerified = true;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _pulseController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    _slideAnimation = Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0, 0.0))
        .animate(CurvedAnimation(
            parent: _slideController, curve: Curves.elasticOut));

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _slideController.forward();
    _pulseController.forward();
    _startCountdown();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && _estimatedArrival > 1) {
        setState(() {
          _estimatedArrival--;
        });
        _startCountdown();
      }
    });
  }

  void _onCallPressed() {
    // Demo limitation - show message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Demo limitation: Call functionality not available',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: AppTheme.lightTheme.colorScheme.onError)),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating));
  }

  void _onMessagePressed() {
    // Demo limitation - show message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Demo limitation: Message functionality not available',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: AppTheme.lightTheme.colorScheme.onError)),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating));
  }

  void _onCancelRide() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Cancel Ride?',
                    style: AppTheme.lightTheme.textTheme.titleLarge),
                content: Text(
                    'Are you sure you want to cancel this ride? Cancellation fees may apply.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Keep Ride')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context)
                            .pop(); // Go back to previous screen
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.error),
                      child: const Text('Cancel Ride')),
                ]));
  }

  void _onReportIssue() {
    Navigator.pushNamed(context, '/support-screen');
  }

  void _showOptionsMenu() {
    // Demo options menu
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Demo limitation: Options menu not available',
            style: AppTheme.lightTheme.textTheme.bodyMedium
                ?.copyWith(color: AppTheme.lightTheme.colorScheme.onError)),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
            backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
                icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface),
                onPressed: () => Navigator.pop(context)),
            title: Text('Your Driver',
                style: AppTheme.lightTheme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.lightTheme.colorScheme.onSurface),
                  onPressed: _showOptionsMenu),
            ]),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              // Vehicle tracking map
              SlideTransition(
                  position: _slideAnimation, child: VehicleTrackingMap()),

              SizedBox(height: 2.h),

              // Driver profile header
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SlideTransition(
                      position: _slideAnimation, 
                      child: DriverProfileHeader(
                        driverName: "John Smith",
                        isVerified: _isDriverVerified,
                        licensePlate: "ABC 123",
                        profileImageUrl: "",
                        rating: 4.8,
                        reviewCount: 245,
                        vehicleColor: "Black",
                        vehicleMake: "Toyota",
                        vehicleModel: "Camry"
                      ))),

              SizedBox(height: 3.h),

              // Driver arrival info
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SlideTransition(
                      position: _slideAnimation, 
                      child: DriverArrivalInfo(
                        estimatedMinutes: _estimatedArrival
                      ))),

              SizedBox(height: 3.h),

              // Driver contact buttons
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SlideTransition(
                      position: _slideAnimation,
                      child: DriverContactButtons(
                        onCallPressed: _onCallPressed,
                        onMessagePressed: _onMessagePressed
                      ))),

              SizedBox(height: 3.h),

              // Trip details info
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SlideTransition(
                      position: _slideAnimation, 
                      child: TripDetailsInfo(
                        destination: "Downtown Mall",
                        fareEstimate: "\$25.50",
                        pickupLocation: "Your Location",
                        specialInstructions: "None"
                      ))),

              SizedBox(height: 3.h),

              // Safety features section
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SlideTransition(
                      position: _slideAnimation,
                      child: SafetyFeaturesSection(
                        onEmergencyPressed: _onReportIssue,
                        onShareTripPressed: _onReportIssue
                      ))),

              SizedBox(height: 12.h), // Extra space for bottom navigation
            ]))),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          // Bottom action buttons
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: BottomActionButtons(
                onCancelRide: _onCancelRide,
                onReportIssue: _onReportIssue
              )),
          // Bottom navigation
          GlobalBottomNavigation(currentIndex: _currentTabIndex),
        ]));
  }
}