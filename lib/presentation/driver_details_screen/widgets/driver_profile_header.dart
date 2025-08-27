import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DriverProfileHeader extends StatelessWidget {
  final String driverName;
  final double rating;
  final int reviewCount;
  final String profileImageUrl;
  final bool isVerified;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleColor;
  final String licensePlate;

  const DriverProfileHeader({
    Key? key,
    required this.driverName,
    required this.rating,
    required this.reviewCount,
    required this.profileImageUrl,
    required this.isVerified,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licensePlate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Driver Profile Photo and Basic Info
          Row(
            children: [
              // Profile Photo
              Stack(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: profileImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            size: 10.w,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                            size: 10.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'verified',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 3.w,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 4.w),

              // Driver Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          driverName,
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isVerified) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'verified',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 5.w,
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Rating
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: Colors.amber,
                          size: 5.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          rating.toString(),
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '($reviewCount reviews)',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Vehicle Information
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'directions_car',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$vehicleColor $vehicleMake $vehicleModel',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Text(
                            'License Plate: ',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            licensePlate,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
