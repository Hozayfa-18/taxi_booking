import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/global_bottom_navigation.dart';
import './widgets/add_payment_bottom_sheet.dart';
import './widgets/add_payment_button.dart';
import './widgets/default_payment_header.dart';
import './widgets/payment_history_section.dart';
import './widgets/payment_method_card.dart';
import './widgets/payment_settings_section.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen>
    with TickerProviderStateMixin {
  late AnimationController _listController;
  late Animation<double> _listAnimation;
  int _currentTabIndex = 2; // Payments tab is active

  List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': '1',
      'type': 'Credit Card',
      'cardNumber': '**** 1234',
      'expiryDate': '12/25',
      'cardType': 'visa',
      'isDefault': true,
    },
    {
      'id': '2',
      'type': 'Credit Card',
      'cardNumber': '**** 5678',
      'expiryDate': '08/26',
      'cardType': 'mastercard',
      'isDefault': false,
    },
    {
      'id': '3',
      'type': 'PayPal',
      'email': 'user@email.com',
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _listAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOutBack,
    ));

    _listController.forward();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _setDefaultPayment(String paymentId) {
    setState(() {
      for (var method in _paymentMethods) {
        method['isDefault'] = method['id'] == paymentId;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Default payment method updated',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deletePaymentMethod(String paymentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Payment Method',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Are you sure you want to delete this payment method?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _paymentMethods
                    .removeWhere((method) => method['id'] == paymentId);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment method deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPaymentBottomSheet(
        onAddPayment: _addPaymentMethod,
      ),
    );
  }

  void _addPaymentMethod(Map<String, dynamic> paymentData) {
    final newPayment = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'type': 'Credit Card',
      'cardNumber':
          '**** ${paymentData['number']?.substring(paymentData['number'].length - 4)}',
      'expiryDate': paymentData['expiry'],
      'cardType': _getCardType(paymentData['number']),
      'isDefault': false,
    };

    setState(() {
      _paymentMethods.add(newPayment);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment method added successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onTertiary,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'visa';
    if (cardNumber.startsWith('5')) return 'mastercard';
    return 'card';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPayment = _paymentMethods.firstWhere(
      (method) => method['isDefault'] == true,
      orElse: () => _paymentMethods.first,
    );

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment Methods',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Help & support coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AnimatedBuilder(
            animation: _listAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  // Default Payment Header
                  Transform.translate(
                    offset: Offset(0, (1 - _listAnimation.value) * 50),
                    child: FadeTransition(
                      opacity: _listAnimation,
                      child: DefaultPaymentHeader(
                        defaultPayment: defaultPayment,
                        onChangePressed: () => _showAddPaymentBottomSheet(),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Payment Methods List
                  Transform.translate(
                    offset: Offset(0, (1 - _listAnimation.value) * 30),
                    child: FadeTransition(
                      opacity: _listAnimation,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'All Payment Methods',
                              style: AppTheme.lightTheme.textTheme.titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _paymentMethods.length,
                              itemBuilder: (context, index) {
                                final payment = _paymentMethods[index];
                                return PaymentMethodCard(
                                  payment: payment,
                                  onSetDefault: () =>
                                      _setDefaultPayment(payment['id']),
                                  onDelete: () =>
                                      _deletePaymentMethod(payment['id']),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Add Payment Button
                  Transform.translate(
                    offset: Offset(0, (1 - _listAnimation.value) * 20),
                    child: FadeTransition(
                      opacity: _listAnimation,
                      child: AddPaymentButton(
                        onPressed: _showAddPaymentBottomSheet,
                      ),
                    ),
                  ),

                  // Payment History Section
                  FadeTransition(
                    opacity: _listAnimation,
                    child: const PaymentHistorySection(),
                  ),

                  // Payment Settings
                  FadeTransition(
                    opacity: _listAnimation,
                    child: const PaymentSettingsSection(),
                  ),

                  SizedBox(height: 12.h), // Extra space for bottom navigation
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: GlobalBottomNavigation(
        currentIndex: _currentTabIndex,
      ),
    );
  }
}
