import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/action_buttons.dart';
import './widgets/driver_info_card.dart';
import './widgets/payment_summary_card.dart';
import './widgets/rating_widget.dart';
import './widgets/route_map_thumbnail.dart';
import './widgets/trip_completion_header.dart';
import './widgets/trip_details_card.dart';

class TripSummaryScreen extends StatefulWidget {
  const TripSummaryScreen({super.key});

  @override
  State<TripSummaryScreen> createState() => _TripSummaryScreenState();
}

class _TripSummaryScreenState extends State<TripSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int _userRating = 0;
  String _feedback = '';
  bool _tipEnabled = true;
  double _tipAmount = 2.00;
  int _currentTabIndex = 1; // History tab as this is typically accessed from there

  @override
  void initState() {
    super.initState();

    // Initialize slide animation for modal
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic));

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this);
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _handleDonePressed() {
    HapticFeedback.lightImpact();
    _slideController.reverse().then((_) {
      _fadeController.reverse().then((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-screen');
        }
      });
    });
  }

  void _handleSaveReceiptPressed() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Demo feature - Receipt saved to downloads',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.all(4.w)));
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
        title: Text(
          'Trip Summary',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600)),
        centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // Trip completion header
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: TripCompletionHeader())),

              SizedBox(height: 3.h),

              // Route map thumbnail
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: RouteMapThumbnail())),

              SizedBox(height: 3.h),

              // Trip details
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: TripDetailsCard())),

              SizedBox(height: 3.h),

              // Driver info
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: DriverInfoCard())),

              SizedBox(height: 3.h),

              // Payment summary
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: PaymentSummaryCard())),

              SizedBox(height: 3.h),

              // Rating section
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: RatingWidget())),

              SizedBox(height: 3.h),

              // Action buttons
              SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ActionButtons(
                    onDonePressed: _handleDonePressed,
                    onSaveReceiptPressed: _handleSaveReceiptPressed))),

              SizedBox(height: 12.h),
            ]))),
      bottomNavigationBar: GlobalBottomNavigation(
        currentIndex: _currentTabIndex));
  }
}