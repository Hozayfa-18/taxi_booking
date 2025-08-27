import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DriverInfoSheet extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onCancelRide;
  final Map<String, dynamic> driverData;
  final Map<String, dynamic> tripDetails;

  const DriverInfoSheet({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    this.onCancelRide,
    required this.driverData,
    required this.tripDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, -8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Enhanced handle bar
            Container(
              width: 14.w,
              height: 0.8.h,
              margin: EdgeInsets.only(top: 2.h, bottom: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            // Main content with enhanced design
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Enhanced driver avatar with status indicator
                      Stack(
                        children: [
                          Container(
                            width: 16.w,
                            height: 16.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.2),
                                  AppTheme
                                      .lightTheme.colorScheme.primaryContainer
                                      .withValues(alpha: 0.3),
                                ],
                              ),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.lightTheme.shadowColor
                                      .withValues(alpha: 0.15),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CustomImageWidget(
                                imageUrl: driverData['avatar'] as String? ??
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                                width: 16.w,
                                height: 16.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Online status indicator
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 4.5.w,
                              height: 4.5.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4.w),

                      // Enhanced driver info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driverData['name'] as String? ?? 'James Wilson',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                letterSpacing: -0.2,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 0.8.h),
                            Row(
                              children: [
                                // Rating with star icon
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFF59E0B)
                                          .withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'star',
                                        color: const Color(0xFFF59E0B),
                                        size: 12,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        driverData['rating'] ?? '4.9',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: const Color(0xFFD97706),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  '(${driverData['ratingsCount'] ?? '2,847'})',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${driverData['vehicle'] ?? 'Toyota Prius'} • ${driverData['plateNumber'] ?? 'LN18 ABC'}',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                fontSize: 11.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Enhanced contact buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildContactButton(
                            icon: 'phone',
                            color: const Color(0xFF10B981),
                            onTap: () => _showDemoMessage(context, 'Call'),
                          ),
                          SizedBox(width: 3.w),
                          _buildContactButton(
                            icon: 'message',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            onTap: () => _showDemoMessage(context, 'Message'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    SizedBox(height: 4.h),
                    _buildExpandedContent(context),
                  ],
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 12.w,
        height: 12.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Enhanced trip details card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(5.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.surface,
                AppTheme.lightTheme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'route',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Trip Details',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              _buildTripDetailRow(
                  'From', tripDetails['from'] ?? 'Piccadilly Circus'),
              SizedBox(height: 1.5.h),
              _buildTripDetailRow('To', tripDetails['to'] ?? 'Tower Bridge'),
              SizedBox(height: 1.5.h),
              _buildTripDetailRow(
                  'Distance', tripDetails['distance'] ?? '3.2 miles'),
              SizedBox(height: 1.5.h),
              _buildTripDetailRow(
                  'Duration', tripDetails['estimatedDuration'] ?? '15 min'),
              SizedBox(height: 1.5.h),
              _buildTripDetailRow('Fare', tripDetails['fare'] ?? '£12.50',
                  isPrice: true),
            ],
          ),
        ),

        SizedBox(height: 3.h),

        // Driver experience info
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primaryContainer
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'shield',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Text(
                '${driverData['yearsExperience'] ?? '5'} years of safe driving',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 4.h),

        // Enhanced cancel ride button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showCancelDialog(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
              side: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
              padding: EdgeInsets.symmetric(vertical: 2.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'cancel',
                  color: const Color(0xFFDC2626),
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Cancel Ride',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFFDC2626),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetailRow(String label, String value,
      {bool isPrice = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: isPrice ? FontWeight.w700 : FontWeight.w600,
            color: isPrice
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  void _showDemoMessage(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              '$action feature disabled in demo mode',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: const Color(0xFFDC2626),
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Cancel Ride?',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: Text(
            'This is a demo. In a real app, cancelling would notify the driver and may incur charges based on timing.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Keep Ride',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onCancelRide != null) {
                  onCancelRide!();
                }
              },
              child: Text(
                'Cancel Ride',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: const Color(0xFFDC2626),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
