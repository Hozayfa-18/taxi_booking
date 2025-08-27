import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/fare_breakdown_card.dart';
import './widgets/payment_method_card.dart';
import './widgets/promo_code_input.dart';
import './widgets/ride_details_card.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _bookingController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _selectedPaymentMethod = 'cash';
  bool _isBooking = false;
  bool _showSuccessAnimation = false;
  String? _appliedPromoDiscount;

  // Mock ride details data
  final Map<String, dynamic> _rideDetails = {
    'vehicleType': 'Economy',
    'vehicleDescription': 'Affordable rides for everyday trips',
    'vehicleIcon': 'directions_car',
    'totalFare': '£12.50',
    'pickupTime': '3-5 min',
    'duration': '15 min',
    'distance': '4.2 km',
    'pickupLocation': 'Piccadilly Circus, London W1J 9HS',
    'dropLocation': 'Tower Bridge, London SE1 2UP',
  };

  // Mock fare breakdown data
  Map<String, dynamic> _fareBreakdown = {
    'baseFare': '£8.50',
    'bookingFee': '£1.50',
    'vat': '£2.50',
    'discount': null,
    'total': '£12.50',
  };

  // Payment methods data
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash',
      'title': 'Cash',
      'subtitle': 'Pay with cash to driver',
      'icon': 'payments',
    },
    {
      'id': 'card',
      'title': 'Card',
      'subtitle': 'Pay with saved card ****1234',
      'icon': 'credit_card',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bookingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    // Start slide animation
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _bookingController.dispose();
    super.dispose();
  }

  void _onPaymentMethodChanged(String paymentId) {
    setState(() {
      _selectedPaymentMethod = paymentId;
    });
    HapticFeedback.lightImpact();
  }

  void _onPromoApplied(String discount) {
    setState(() {
      _appliedPromoDiscount = discount;
      _fareBreakdown['discount'] = discount;

      // Recalculate total
      double baseFare =
          double.parse(_fareBreakdown['baseFare']!.replaceAll('£', ''));
      double bookingFee =
          double.parse(_fareBreakdown['bookingFee']!.replaceAll('£', ''));
      double vat = double.parse(_fareBreakdown['vat']!.replaceAll('£', ''));
      double discountAmount = double.parse(discount.replaceAll('£', ''));

      double newTotal = baseFare + bookingFee + vat - discountAmount;
      _fareBreakdown['total'] = '£${newTotal.toStringAsFixed(2)}';
      _rideDetails['totalFare'] = '£${newTotal.toStringAsFixed(2)}';
    });
    HapticFeedback.mediumImpact();
  }

  void _onPromoRemoved() {
    setState(() {
      _appliedPromoDiscount = null;
      _fareBreakdown['discount'] = null;
      _fareBreakdown['total'] = '£12.50';
      _rideDetails['totalFare'] = '£12.50';
    });
  }

  Future<void> _bookRide() async {
    if (_isBooking) return;

    setState(() {
      _isBooking = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate booking process
    await Future.delayed(const Duration(milliseconds: 2500));

    setState(() {
      _isBooking = false;
      _showSuccessAnimation = true;
    });

    // Show success animation
    _bookingController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/ride-tracking-screen');
    }
  }

  void _goBack() {
    _slideController.reverse().then((_) {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: Stack(
        children: [
          // Background tap to close
          GestureDetector(
            onTap: _goBack,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
            ),
          ),

          // Bottom sheet content
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  height: 75.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        width: 12.w,
                        height: 0.5.h,
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Header
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _goBack,
                              child: Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.lightTheme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.outline
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'arrow_back',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                'Confirm Booking',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ride details card
                              RideDetailsCard(rideDetails: _rideDetails),

                              // Payment methods section
                              Text(
                                'Payment Method',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 2.h),

                              // Payment method cards
                              ...(_paymentMethods
                                  .map((method) => PaymentMethodCard(
                                        title: method['title'],
                                        subtitle: method['subtitle'],
                                        iconName: method['icon'],
                                        isSelected: _selectedPaymentMethod ==
                                            method['id'],
                                        onTap: () => _onPaymentMethodChanged(
                                            method['id']),
                                      ))
                                  .toList()),

                              // Promo code input
                              PromoCodeInput(
                                onPromoApplied: _onPromoApplied,
                                onPromoRemoved: _onPromoRemoved,
                              ),

                              // Fare breakdown
                              FareBreakdownCard(fareDetails: _fareBreakdown),

                              SizedBox(height: 10.h), // Space for bottom button
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _isBooking ? null : _bookRide,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isBooking
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  'Booking Ride...',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              'Book Ride • ${_fareBreakdown['total']}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Success animation overlay
          if (_showSuccessAnimation)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.8),
              child: Center(
                child: AnimatedBuilder(
                  animation: _bookingController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _bookingController.value,
                      child: Opacity(
                        opacity: _bookingController.value,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                size: 48,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Ride Booked!',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
