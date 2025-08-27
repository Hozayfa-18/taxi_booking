import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedCarMarker extends StatefulWidget {
  final double rotation;
  final bool isMoving;
  final double scale;

  const AnimatedCarMarker({
    super.key,
    required this.rotation,
    this.isMoving = false,
    this.scale = 1.0,
  });

  @override
  State<AnimatedCarMarker> createState() => _AnimatedCarMarkerState();
}

class _AnimatedCarMarkerState extends State<AnimatedCarMarker>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shadowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for when the car is moving
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Shadow animation for more realistic depth
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _shadowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _shadowController,
      curve: Curves.easeInOut,
    ));

    if (widget.isMoving) {
      _pulseController.repeat(reverse: true);
      _shadowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedCarMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMoving && !oldWidget.isMoving) {
      _pulseController.repeat(reverse: true);
      _shadowController.repeat(reverse: true);
    } else if (!widget.isMoving && oldWidget.isMoving) {
      _pulseController.stop();
      _shadowController.stop();
      _pulseController.reset();
      _shadowController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shadowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.scale * (widget.isMoving ? _pulseAnimation.value : 1.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Car shadow (appears when moving)
              if (widget.isMoving)
                Positioned(
                  top: 2,
                  left: 2,
                  child: Transform.rotate(
                    angle: widget.rotation,
                    child: Container(
                      width: 10.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withValues(alpha: _shadowAnimation.value * 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

              // Main car body
              Transform.rotate(
                angle: widget.rotation,
                child: Container(
                  width: 10.w,
                  height: 5.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.9),
                        AppTheme.lightTheme.colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: widget.isMoving ? 0.4 : 0.2),
                        blurRadius: widget.isMoving ? 12 : 8,
                        spreadRadius: widget.isMoving ? 2 : 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Car windows
                      Positioned(
                        top: 0.3.w,
                        left: 0.8.w,
                        right: 0.8.w,
                        child: Container(
                          height: 1.8.w,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1E40AF).withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      // Car headlights (when moving)
                      if (widget.isMoving) ...[
                        Positioned(
                          top: 0.2.w,
                          left: 0.2.w,
                          child: Container(
                            width: 1.w,
                            height: 0.8.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFEF3C7)
                                      .withValues(alpha: 0.6),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.2.w,
                          right: 0.2.w,
                          child: Container(
                            width: 1.w,
                            height: 0.8.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFEF3C7)
                                      .withValues(alpha: 0.6),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      // Car icon overlay
                      Center(
                        child: CustomIconWidget(
                          iconName: 'directions_car',
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.8),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Movement trail effect (when moving)
              if (widget.isMoving)
                Transform.rotate(
                  angle: widget.rotation,
                  child: Container(
                    width: 14.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.0,
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.0),
                          AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: _pulseAnimation.value * 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
