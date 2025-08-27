import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentSettingsSection extends StatefulWidget {
  const PaymentSettingsSection({Key? key}) : super(key: key);

  @override
  State<PaymentSettingsSection> createState() => _PaymentSettingsSectionState();
}

class _PaymentSettingsSectionState extends State<PaymentSettingsSection> {
  bool _autoPaymentEnabled = true;
  bool _emailReceiptsEnabled = true;
  String _selectedCurrency = 'USD';

  final List<Map<String, String>> _currencies = [
    {'code': 'USD', 'name': 'US Dollar'},
    {'code': 'EUR', 'name': 'Euro'},
    {'code': 'GBP', 'name': 'British Pound'},
    {'code': 'CAD', 'name': 'Canadian Dollar'},
    {'code': 'AUD', 'name': 'Australian Dollar'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Payment Settings',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Auto Payment Toggle
          _buildSettingRow(
            iconName: 'autorenew',
            iconColor: AppTheme.lightTheme.colorScheme.primary,
            title: 'Auto Payment',
            subtitle: 'Automatically charge default payment method',
            trailing: Switch(
              value: _autoPaymentEnabled,
              onChanged: (value) {
                setState(() {
                  _autoPaymentEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value ? 'Auto payment enabled' : 'Auto payment disabled',
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Email Receipts Toggle
          _buildSettingRow(
            iconName: 'email',
            iconColor: Colors.green.shade600,
            title: 'Email Receipts',
            subtitle: 'Send payment receipts to your email',
            trailing: Switch(
              value: _emailReceiptsEnabled,
              onChanged: (value) {
                setState(() {
                  _emailReceiptsEnabled = value;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? 'Email receipts enabled'
                          : 'Email receipts disabled',
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Currency Selection
          _buildSettingRow(
            iconName: 'attach_money',
            iconColor: Colors.orange.shade600,
            title: 'Currency',
            subtitle: _currencies.firstWhere(
              (currency) => currency['code'] == _selectedCurrency,
            )['name']!,
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            onTap: _showCurrencySelection,
          ),

          SizedBox(height: 2.h),

          // Manage Auto-Payment
          _buildSettingRow(
            iconName: 'schedule',
            iconColor: Colors.blue.shade600,
            title: 'Manage Auto-Payment',
            subtitle: 'Set up recurring payment preferences',
            trailing: CustomIconWidget(
              iconName: 'chevron_right',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Auto-payment management coming soon'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required String iconName,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _showCurrencySelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Currency',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _currencies.length,
              itemBuilder: (context, index) {
                final currency = _currencies[index];
                final isSelected = currency['code'] == _selectedCurrency;

                return ListTile(
                  title: Text(currency['name']!),
                  subtitle: Text(currency['code']!),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCurrency = currency['code']!;
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Currency changed to ${currency['name']}'),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
