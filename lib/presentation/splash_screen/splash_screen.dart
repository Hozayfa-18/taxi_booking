import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;

  bool _isLoading = true;
  bool _hasError = false;
  int _retryCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Pulse animation for AI effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Floating animation for subtle movement
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Scale animation with elastic effect
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );

    // Slide animation for text
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // AI pulse effect
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Floating effect
    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    // Start animations
    _mainController.forward();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  Future<void> _initializeApp() async {
    try {
      // Enhanced loading simulation with ride-sharing services
      await Future.delayed(const Duration(milliseconds: 1200));

      // Simulate loading ride services
      await _loadRideServices();

      // Simulate loading static map tiles
      await Future.delayed(const Duration(milliseconds: 600));

      // Prepare enhanced ride data
      await _loadRideData();

      // Initialize ride-sharing animations
      await Future.delayed(const Duration(milliseconds: 400));

      // Prepare premium features
      await _preparePremiumFeatures();

      // Additional loading for smooth experience
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate with enhanced transition
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home-screen');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });

        // Auto retry with enhanced feedback
        if (_retryCount == 0) {
          await Future.delayed(const Duration(seconds: 5));
          if (mounted) {
            _retryInitialization();
          }
        }
      }
    }
  }

  Future<void> _loadRideServices() async {
    // Simulate loading ride-sharing services
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _loadRideData() async {
    // Simulate loading enhanced ride data with location services
    await Future.delayed(const Duration(milliseconds: 400));
  }

  Future<void> _preparePremiumFeatures() async {
    // Simulate preparing premium ride features
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _retryCount++;
    });
    _mainController.reset();
    _mainController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Enhanced status bar styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.aiLinearGradient),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _mainController,
              _pulseController,
              _floatingController,
            ]),
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Floating logo section with AI effects
                  Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white,
                                Colors.white.withValues(alpha: 0.9),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: AppTheme.primaryLight.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // AI pulse ring
                              Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  width: 35.w,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.primaryLight.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),

                              // Main car icon
                              CustomIconWidget(
                                    iconName: 'directions_car',
                                    color: AppTheme.primaryLight,
                                    size: 20.w,
                                  )
                                  .animate()
                                  .rotate(
                                    duration: const Duration(
                                      milliseconds: 2000,
                                    ),
                                    curve: Curves.easeInOut,
                                    begin: -0.1,
                                    end: 0.1,
                                  )
                                  .then()
                                  .rotate(
                                    duration: const Duration(
                                      milliseconds: 2000,
                                    ),
                                    curve: Curves.easeInOut,
                                    begin: 0.1,
                                    end: -0.1,
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // App name with slide animation
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.white.withValues(alpha: 0.7),
                        period: const Duration(milliseconds: 1500),
                        child: Text(
                          'Ride',
                          style: AppTheme.lightTheme.textTheme.displayMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1.0,
                              ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 1.5.h),

                  // Subtitle with enhanced animation
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 0.5),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                            'Your Reliable Ride Partner',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                          )
                          .animate(delay: const Duration(milliseconds: 800))
                          .fadeIn(duration: const Duration(milliseconds: 1000))
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutCubic,
                          ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Enhanced loading/error section
                  _buildStatusSection(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    if (_hasError) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'error_outline',
              color: Colors.white.withValues(alpha: 0.8),
              size: 8.w,
            ),
          ).animate().shake(duration: const Duration(milliseconds: 800)),
          SizedBox(height: 3.h),
          Text(
            'Unable to initialize ride services',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 3.h),
          if (_retryCount < 2)
            ElevatedButton(
              onPressed: _retryInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryLight,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
              child: Text(
                'Retry Loading',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ).animate().scaleXY(
              begin: 0.8,
              end: 1.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
            ),
        ],
      );
    }

    if (_isLoading) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer loading ring
              Container(
                    width: 12.w,
                    height: 12.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(duration: const Duration(milliseconds: 2000)),

              // Inner loading core
              Container(
                    width: 8.w,
                    height: 8.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .rotate(
                    duration: const Duration(milliseconds: 1500),
                    begin: 1.0,
                    end: 0.0,
                  ),
            ],
          ),
          SizedBox(height: 4.h),
          Shimmer.fromColors(
            baseColor: Colors.white.withValues(alpha: 0.7),
            highlightColor: Colors.white,
            period: const Duration(milliseconds: 1200),
            child: Text(
              'Initializing ride services...',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
                'Loading location services',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              )
              .animate(delay: const Duration(milliseconds: 1000))
              .fadeIn(duration: const Duration(milliseconds: 800))
              .slideY(begin: 0.2, end: 0),
        ],
      );
    }

    return Container();
  }
}
