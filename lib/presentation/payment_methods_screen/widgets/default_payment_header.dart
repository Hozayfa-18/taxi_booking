import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DefaultPaymentHeader extends StatelessWidget {
  final Map<String, dynamic> defaultPayment;
  final VoidCallback onChangePressed;

  const DefaultPaymentHeader({
    Key? key,
    required this.defaultPayment,
    required this.onChangePressed,
  }) : super(key: key);

  String _getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return 'credit_card';
      case 'mastercard':
        return 'credit_card';
      case 'paypal':
        return 'paypal';
      default:
        return 'payment';
    }
  }

  Color _getCardColor(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return Colors.blue.shade600;
      case 'mastercard':
        return Colors.red.shade600;
      case 'paypal':
        return Colors.indigo.shade600;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Default Badge
          Row(
            children: [
              CustomIconWidget(
                iconName: 'wallet',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Default Payment',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'DEFAULT',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Payment Method Details
          Row(
            children: [
              // Card Icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CustomIconWidget(
                  iconName: _getCardIcon(defaultPayment['cardType'] ?? 'card'),
                  color: _getCardColor(defaultPayment['cardType'] ?? 'card'),
                  size: 6.w,
                ),
              ),

              SizedBox(width: 4.w),

              // Payment Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      defaultPayment['type'] ?? 'Payment Method',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    if (defaultPayment['cardNumber'] != null)
                      Text(
                        defaultPayment['cardNumber'],
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    else if (defaultPayment['email'] != null)
                      Text(
                        defaultPayment['email'],
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (defaultPayment['expiryDate'] != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        'Expires ${defaultPayment['expiryDate']}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onPrimary
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Change Payment Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onChangePressed,
              icon: CustomIconWidget(
                iconName: 'swap_horiz',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text(
                'Change Default Payment',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  width: 2,
                ),
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
