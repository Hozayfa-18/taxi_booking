import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomActionButtons extends StatelessWidget {
  final VoidCallback onCancelRide;
  final VoidCallback onReportIssue;

  const BottomActionButtons({
    Key? key,
    required this.onCancelRide,
    required this.onReportIssue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Report Issue Button
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReportIssue,
                icon: CustomIconWidget(
                  iconName: 'report_problem',
                  color: Colors.orange.shade600,
                  size: 5.w,
                ),
                label: Text(
                  'Report Issue',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: Colors.orange.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.orange.shade600,
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Cancel Ride Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onCancelRide,
                icon: CustomIconWidget(
                  iconName: 'cancel',
                  color: AppTheme.lightTheme.colorScheme.onError,
                  size: 5.w,
                ),
                label: Text(
                  'Cancel Ride',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onError,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onError,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
