import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class OnboardingPageData {
  final String title;
  final String description;
  final IconData image;
  final Color color;
  
  OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  
  const OnboardingPage({
    super.key,
    required this.data,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.image,
              size: 100,
              color: data.color,
            ),
          )
              .animate()
              .scale(
                duration: 800.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(),
          
          const SizedBox(height: AppSpacing.xxxl),
          
          // Title
          Text(
            data.title,
            style: AppTypography.h2.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 300.ms)
              .slideY(begin: 0.2, end: 0),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Description
          Text(
            data.description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 500.ms)
              .slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }
}