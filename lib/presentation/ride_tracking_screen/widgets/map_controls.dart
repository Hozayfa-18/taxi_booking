import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MapControls extends StatelessWidget {
  final VoidCallback onCenterRoute;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  const MapControls({
    super.key,
    required this.onCenterRoute,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 4.w,
      top: 15.h,
      child: Column(
        children: [
          // Center on route button
          _buildControlButton(
            icon: 'my_location',
            onTap: onCenterRoute,
            tooltip: 'Center on Route',
          ),

          SizedBox(height: 2.h),

          // Zoom controls
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildZoomButton(
                  icon: 'add',
                  onTap: onZoomIn,
                  isTop: true,
                ),
                Container(
                  height: 1,
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
                _buildZoomButton(
                  icon: 'remove',
                  onTap: onZoomOut,
                  isTop: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required String icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButton({
    required String icon,
    required VoidCallback onTap,
    required bool isTop,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: isTop ? const Radius.circular(12) : Radius.zero,
            bottom: !isTop ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 20,
          ),
        ),
      ),
    );
  }
}
