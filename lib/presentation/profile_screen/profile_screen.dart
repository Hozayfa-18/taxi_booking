import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/loyalty_tier_widget.dart';
import './widgets/profile_photo_widget.dart';
import './widgets/settings_list_widget.dart';
import './widgets/user_info_form_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Profile tab is active (fourth tab)

  // Mock user data
  String _userName = 'Sarah Johnson';
  String _userEmail = 'sarah.johnson@email.com';

  // Mock loyalty data
  final Map<String, dynamic> _loyaltyData = {
    'currentTier': 'Gold Member',
    'currentPoints': 2450,
    'nextTierPoints': 3000,
    'benefits': [
      'Priority booking',
      '10% discount on rides',
      'Free ride cancellation',
      '24/7 premium support',
    ],
  };

  void _handlePhotoTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Change Profile Photo',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _showDemoMessage('Camera functionality disabled in demo mode');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _showDemoMessage('Gallery access disabled in demo mode');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _handleUserInfoSave(String name, String email) {
    setState(() {
      _userName = name;
      _userEmail = email;
    });
  }

  void _handleSettingTap(String action) {
    String message = '';
    switch (action) {
      case 'payment':
        message = 'Payment methods: Demo cards only';
        break;
      case 'privacy':
        message = 'Privacy settings available in full version';
        break;
      case 'help':
        message = 'Help & Support: Contact demo@rideshare.com';
        break;
      case 'about':
        message = 'RideShare Demo v1.0.0 - Built with Flutter';
        break;
      default:
        message = 'Feature available in full version';
    }
    _showDemoMessage(message);
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/splash-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDemoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history-screen');
        break;
      case 2:
        // Already on profile screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.h),
              // Profile Photo Section
              ProfilePhotoWidget(
                onTap: _handlePhotoTap,
              ),
              SizedBox(height: 3.h),

              // User Info Form
              UserInfoFormWidget(
                initialName: _userName,
                initialEmail: _userEmail,
                onSave: _handleUserInfoSave,
              ),

              SizedBox(height: 2.h),

              // Loyalty Tier Display
              LoyaltyTierWidget(
                currentTier: _loyaltyData['currentTier'],
                currentPoints: _loyaltyData['currentPoints'],
                nextTierPoints: _loyaltyData['nextTierPoints'],
                benefits: (_loyaltyData['benefits'] as List).cast<String>(),
              ),

              SizedBox(height: 2.h),

              // Settings List
              SettingsListWidget(
                onSettingTap: _handleSettingTap,
                onLogout: _handleLogout,
              ),

              SizedBox(height: 12.h), // Extra space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: GlobalBottomNavigation(
        currentIndex: _currentIndex,
      ),
    );
  }
}
