import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback onSearchPressed;

  const SearchBarWidget({
    super.key,
    required this.onSearchPressed,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start subtle animations
    _shimmerController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isHovered ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: widget.onSearchPressed,
            onTapDown: (_) => setState(() => _isHovered = true),
            onTapUp: (_) => setState(() => _isHovered = false),
            onTapCancel: () => setState(() => _isHovered = false),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 5.w,
                vertical: 2.h,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.98),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryLight.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // AI-powered search icon with animation
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryLinearGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryLight.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(
                        duration: const Duration(milliseconds: 3000),
                        curve: Curves.easeInOut,
                        begin: 0,
                        end: 0.1,
                      )
                      .then()
                      .rotate(
                        duration: const Duration(milliseconds: 3000),
                        curve: Curves.easeInOut,
                        begin: 0.1,
                        end: -0.1,
                      )
                      .then()
                      .rotate(
                        duration: const Duration(milliseconds: 3000),
                        curve: Curves.easeInOut,
                        begin: -0.1,
                        end: 0,
                      ),

                  SizedBox(width: 4.w),

                  // Main search content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // AI-enhanced main text
                        Shimmer.fromColors(
                          baseColor: AppTheme.textPrimaryLight,
                          highlightColor:
                              AppTheme.primaryLight.withValues(alpha: 0.6),
                          period: const Duration(milliseconds: 2000),
                          child: Text(
                            'Where to?',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimaryLight,
                            ),
                          ),
                        ),

                        SizedBox(height: 0.5.h),

                        // AI prediction subtitle
                        Row(
                          children: [
                            Icon(
                              Icons.psychology_outlined,
                              size: 14,
                              color: AppTheme.textSecondaryLight,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'AI will suggest the best route',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Forward arrow with gradient
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.secondaryLight.withValues(alpha: 0.1),
                          AppTheme.secondaryLight.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.primaryLight,
                      size: 18,
                    ),
                  ).animate(delay: const Duration(milliseconds: 600)).slideX(
                        begin: 0.3,
                        end: 0,
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                      ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(duration: const Duration(milliseconds: 800)).slideY(
          begin: 0.5,
          end: 0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
        );
  }
}
