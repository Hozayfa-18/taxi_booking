import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class RatingWidget extends StatefulWidget {
  const RatingWidget({super.key});

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget>
    with TickerProviderStateMixin {
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  late AnimationController _starAnimationController;
  late List<Animation<double>> _starAnimations;

  @override
  void initState() {
    super.initState();
    _starAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _starAnimations = List.generate(5, (index) {
      return Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _starAnimationController,
        curve: Interval(
          index * 0.1,
          (index * 0.1) + 0.3,
          curve: Curves.elasticOut,
        ),
      ));
    });
  }

  @override
  void dispose() {
    _starAnimationController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _onStarTap(int rating) {
    setState(() {
      _selectedRating = rating;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Animate stars
    _starAnimationController.forward().then((_) {
      _starAnimationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rate your trip',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 2.h),

          // Star rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isSelected = starIndex <= _selectedRating;

              return AnimatedBuilder(
                animation: _starAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _selectedRating > 0
                        ? _starAnimations[index].value
                        : 1.0,
                    child: GestureDetector(
                      onTap: () => _onStarTap(starIndex),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        child: CustomIconWidget(
                          iconName: isSelected ? 'star' : 'star_border',
                          color: isSelected
                              ? Colors.amber
                              : AppTheme.lightTheme.colorScheme.outline,
                          size: 8.w,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          SizedBox(height: 1.h),

          // Rating text
          Center(
            child: Text(
              _getRatingText(_selectedRating),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Feedback text field
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'How was your ride? (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.all(3.w),
              fillColor: AppTheme.lightTheme.colorScheme.surface,
              filled: true,
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap to rate';
    }
  }
}
