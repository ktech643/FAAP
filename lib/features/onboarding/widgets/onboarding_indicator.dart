import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class OnboardingIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;
  
  const OnboardingIndicator({
    super.key,
    required this.pageCount,
    required this.currentPage,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => _buildIndicator(index == currentPage, index),
      ),
    );
  }
  
  Widget _buildIndicator(bool isActive, int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryGreen : AppColors.gray300,
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        );
  }
}