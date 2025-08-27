import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/demo_banner_widget.dart';
import './widgets/map_canvas_widget.dart';
import './widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentTabIndex = 0;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _mapController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _mapFadeAnimation;

  bool _isMapLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _simulateMapLoading();
  }

  void _initializeAnimations() {
    // Slide animation for search bar
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Pulse animation for AI effects
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Map loading animation
    _mapController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _mapFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mapController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _simulateMapLoading() async {
    // Simulate AI-powered map loading
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {
        _isMapLoaded = true;
      });
      _mapController.forward();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    // Add haptic feedback for premium feel
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/fare-selection-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced header with AI branding
            _buildAIHeader()
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 600))
                .slideY(
                  begin: -0.3,
                  end: 0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                ),

            // Map area with AI loading effects
            Expanded(
              child: Stack(
                children: [
                  // Map canvas with fade animation
                  AnimatedBuilder(
                    animation: _mapFadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _mapFadeAnimation.value,
                        child: const MapCanvasWidget(),
                      );
                    },
                  ),

                  // AI loading overlay
                  if (!_isMapLoaded)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppTheme.primaryLight.withValues(alpha: 0.1),
                            AppTheme.secondaryLight.withValues(alpha: 0.05),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // AI loading indicator
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: AppTheme.primaryLinearGradient,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryLight
                                              .withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            Shimmer.fromColors(
                              baseColor: AppTheme.primaryLight,
                              highlightColor: AppTheme.primaryVariantLight,
                              child: Text(
                                'AI Mapping Intelligence Loading...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Demo banner overlay
                  const DemoBannerWidget(),

                  // Floating AI features indicator
                  if (_isMapLoaded)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: AppTheme.aiLinearGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AI Active',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate(delay: const Duration(milliseconds: 1200))
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideX(
                          begin: 1.0,
                          end: 0.0,
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                        ),
                ],
              ),
            ),

            // Enhanced search bar section with animations
            AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: SearchBarWidget(
                      onSearchPressed: _onSearchPressed,
                    ),
                  ),
                );
              },
            ).animate(delay: const Duration(milliseconds: 400)).shimmer(
                  duration: const Duration(milliseconds: 1200),
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                ),
          ],
        ),
      ),

      // Enhanced bottom navigation
      bottomNavigationBar: GlobalBottomNavigation(
        currentIndex: _currentTabIndex,
      ).animate().fadeIn(duration: const Duration(milliseconds: 800)).slideY(
            begin: 1.0,
            end: 0.0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutCubic,
          ),
    );
  }

  Widget _buildAIHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // AI-powered greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getTimeGreeting()}!',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Where would you like to go?',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // AI profile indicator
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryLinearGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 24,
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(
                begin: 1.0,
                end: 1.05,
                duration: const Duration(milliseconds: 2000),
                curve: Curves.easeInOut,
              ),
        ],
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}