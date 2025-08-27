import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/continue_button.dart';
import './widgets/fare_option_card.dart';
import './widgets/fare_selection_header.dart';

class FareSelectionScreen extends StatefulWidget {
  const FareSelectionScreen({Key? key}) : super(key: key);

  @override
  State<FareSelectionScreen> createState() => _FareSelectionScreenState();
}

class _FareSelectionScreenState extends State<FareSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  int? _selectedFareIndex;
  bool _showPulseAnimation = false;

  // Mock fare options data
  final List<Map<String, dynamic>> _fareOptions = [
    {
      "id": 1,
      "name": "Economy",
      "icon": "directions_car",
      "capacity": "4",
      "description": "Affordable rides",
      "eta": "3-5 min",
      "price": "£12.50",
      "originalPrice": null,
      "features": ["Standard vehicle", "Shared ride option"]
    },
    {
      "id": 2,
      "name": "Comfort",
      "icon": "car_rental",
      "capacity": "4",
      "description": "Premium vehicles",
      "eta": "2-4 min",
      "price": "£18.75",
      "originalPrice": "£22.00",
      "features": ["Premium vehicle", "Extra legroom", "Climate control"]
    },
    {
      "id": 3,
      "name": "XL",
      "icon": "airport_shuttle",
      "capacity": "6",
      "description": "Extra space",
      "eta": "4-6 min",
      "price": "£25.00",
      "originalPrice": null,
      "features": ["Large vehicle", "Extra luggage space", "Group rides"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startPulseTimer();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start slide animation
    _slideController.forward();
  }

  void _startPulseTimer() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted && _selectedFareIndex == null) {
        setState(() {
          _showPulseAnimation = true;
        });
        _pulseController.repeat(reverse: true);
      }
    });
  }

  void _selectFare(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFareIndex = index;
      _showPulseAnimation = false;
    });
    _pulseController.stop();
  }

  void _onContinue() {
    if (_selectedFareIndex != null) {
      HapticFeedback.mediumImpact();
      Navigator.pushNamed(context, '/booking-confirmation-screen');
    }
  }

  void _onClose() {
    _slideController.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5),
      body: GestureDetector(
        onTap: _onClose,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              // Top spacer (maintains map visibility)
              Expanded(
                flex: 1,
                child: Container(),
              ),

              // Bottom sheet content
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () {}, // Prevent tap through
                  child: AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, (1 - _slideAnimation.value) * 100.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Header
                              FareSelectionHeader(onClose: _onClose),

                              // Fare options list
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 1.h),
                                  itemCount: _fareOptions.length,
                                  itemBuilder: (context, index) {
                                    final fareOption = _fareOptions[index];
                                    final isSelected =
                                        _selectedFareIndex == index;

                                    Widget card = FareOptionCard(
                                      fareOption: fareOption,
                                      isSelected: isSelected,
                                      onTap: () => _selectFare(index),
                                    );

                                    // Apply pulse animation if needed
                                    if (_showPulseAnimation && !isSelected) {
                                      return AnimatedBuilder(
                                        animation: _pulseAnimation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _pulseAnimation.value,
                                            child: card,
                                          );
                                        },
                                      );
                                    }

                                    return card;
                                  },
                                ),
                              ),

                              // Continue button
                              ContinueButton(
                                isEnabled: _selectedFareIndex != null,
                                onPressed: _onContinue,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
