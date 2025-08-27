import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SettingsListWidget extends StatefulWidget {
  final Function(String) onSettingTap;
  final VoidCallback onLogout;

  const SettingsListWidget({
    Key? key,
    required this.onSettingTap,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<SettingsListWidget> createState() => _SettingsListWidgetState();
}

class _SettingsListWidgetState extends State<SettingsListWidget> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;

  final List<Map<String, dynamic>> _settingsItems = [
    {
      'title': 'Payment Methods',
      'subtitle': '2 cards on file',
      'icon': 'payment',
      'action': 'payment',
      'hasSwitch': false,
    },
    {
      'title': 'Notifications',
      'subtitle': 'Push notifications and alerts',
      'icon': 'notifications',
      'action': 'notifications',
      'hasSwitch': true,
      'switchKey': 'notifications',
    },
    {
      'title': 'Location Services',
      'subtitle': 'Allow location access',
      'icon': 'location_on',
      'action': 'location',
      'hasSwitch': true,
      'switchKey': 'location',
    },
    {
      'title': 'Privacy Settings',
      'subtitle': 'Data and privacy controls',
      'icon': 'privacy_tip',
      'action': 'privacy',
      'hasSwitch': false,
    },
    {
      'title': 'Help & Support',
      'subtitle': 'Get help and contact us',
      'icon': 'help_outline',
      'action': 'help',
      'hasSwitch': false,
    },
    {
      'title': 'About',
      'subtitle': 'App version and legal info',
      'icon': 'info_outline',
      'action': 'about',
      'hasSwitch': false,
    },
  ];

  void _handleSwitchChange(String key, bool value) {
    setState(() {
      if (key == 'notifications') {
        _notificationsEnabled = value;
      } else if (key == 'location') {
        _locationEnabled = value;
      }
    });
  }

  bool _getSwitchValue(String key) {
    if (key == 'notifications') return _notificationsEnabled;
    if (key == 'location') return _locationEnabled;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _settingsItems.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppTheme.lightTheme.dividerColor,
              indent: 4.w,
              endIndent: 4.w,
            ),
            itemBuilder: (context, index) {
              final item = _settingsItems[index];
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                leading: Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: item['icon'],
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                ),
                title: Text(
                  item['title'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'],
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
                trailing: item['hasSwitch'] == true
                    ? Switch(
                        value: _getSwitchValue(item['switchKey']),
                        onChanged: (value) =>
                            _handleSwitchChange(item['switchKey'], value),
                      )
                    : CustomIconWidget(
                        iconName: 'chevron_right',
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.4),
                        size: 5.w,
                      ),
                onTap: item['hasSwitch'] != true
                    ? () => widget.onSettingTap(item['action'])
                    : null,
              );
            },
          ),
          Divider(
            height: 1,
            color: AppTheme.lightTheme.dividerColor,
            indent: 4.w,
            endIndent: 4.w,
          ),
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            leading: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'logout',
                color: Colors.red,
                size: 5.w,
              ),
            ),
            title: Text(
              'Logout',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            subtitle: Text(
              'Sign out of your account',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            onTap: widget.onLogout,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
