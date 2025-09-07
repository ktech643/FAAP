import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/search_provider.dart';

class EmptySearchWidget extends StatelessWidget {
  final String query;
  final SearchType searchType;
  
  const EmptySearchWidget({
    super.key,
    required this.query,
    required this.searchType,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.gray400,
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),
            
            const SizedBox(height: AppSpacing.xl),
            
            Text(
              'No results found',
              style: AppTypography.h4.copyWith(
                color: AppColors.textPrimary,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms),
            
            const SizedBox(height: AppSpacing.sm),
            
            Text(
              'No ${_getSearchTypeText()} found for "$query"',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 400.ms),
            
            const SizedBox(height: AppSpacing.xxl),
            
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.gray50,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                children: [
                  _buildSuggestion(
                    icon: Icons.check_circle_outline,
                    text: 'Check your spelling',
                    delay: 500.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSuggestion(
                    icon: Icons.search,
                    text: 'Try different keywords',
                    delay: 600.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSuggestion(
                    icon: Icons.category,
                    text: 'Try a different category',
                    delay: 700.ms,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSuggestion({
    required IconData icon,
    required String text,
    required Duration delay,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSpacing.iconSm,
          color: AppColors.primaryGreen,
        ),
        const SizedBox(width: AppSpacing.md),
        Text(
          text,
          style: AppTypography.body.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay)
        .slideX(begin: -0.1, end: 0);
  }
  
  String _getSearchTypeText() {
    switch (searchType) {
      case SearchType.all:
        return 'results';
      case SearchType.products:
        return 'products';
      case SearchType.additives:
        return 'additives';
      case SearchType.brands:
        return 'brands';
    }
  }
}