import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class PromoCodeInput extends StatefulWidget {
  final Function(String) onPromoApplied;
  final Function() onPromoRemoved;

  const PromoCodeInput({
    Key? key,
    required this.onPromoApplied,
    required this.onPromoRemoved,
  }) : super(key: key);

  @override
  State<PromoCodeInput> createState() => _PromoCodeInputState();
}

class _PromoCodeInputState extends State<PromoCodeInput> {
  final TextEditingController _promoController = TextEditingController();
  bool _isApplying = false;
  bool _isPromoApplied = false;
  String _appliedPromoCode = '';
  String? _errorMessage;

  // Mock promo codes for demonstration
  final Map<String, String> _validPromoCodes = {
    'SAVE10': '£2.50',
    'FIRST20': '£5.00',
    'WELCOME': '£3.00',
    'STUDENT': '£1.50',
  };

  Future<void> _applyPromoCode() async {
    final promoCode = _promoController.text.trim().toUpperCase();

    if (promoCode.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a promo code';
      });
      return;
    }

    setState(() {
      _isApplying = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (_validPromoCodes.containsKey(promoCode)) {
      setState(() {
        _isApplying = false;
        _isPromoApplied = true;
        _appliedPromoCode = promoCode;
        _errorMessage = null;
      });
      widget.onPromoApplied(_validPromoCodes[promoCode]!);
    } else {
      setState(() {
        _isApplying = false;
        _errorMessage = 'Invalid promo code';
      });
    }
  }

  void _removePromoCode() {
    setState(() {
      _isPromoApplied = false;
      _appliedPromoCode = '';
      _promoController.clear();
      _errorMessage = null;
    });
    widget.onPromoRemoved();
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Promo Code',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          if (_isPromoApplied) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promo Applied: $_appliedPromoCode',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        ),
                        Text(
                          'You saved ${_validPromoCodes[_appliedPromoCode]}!',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _removePromoCode,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _promoController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      errorText: _errorMessage,
                      suffixIcon: _promoController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _promoController.clear();
                                setState(() {
                                  _errorMessage = null;
                                });
                              },
                              child: CustomIconWidget(
                                iconName: 'clear',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = null;
                      });
                    },
                    onFieldSubmitted: (_) => _applyPromoCode(),
                  ),
                ),
                SizedBox(width: 3.w),
                SizedBox(
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isApplying ? null : _applyPromoCode,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isApplying
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Apply',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            if (_errorMessage == null && !_isApplying) ...[
              SizedBox(height: 1.h),
              Text(
                'Try: SAVE10, FIRST20, WELCOME, STUDENT',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
