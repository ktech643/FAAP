import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTapped;
  final Function(String) onRemove;
  final VoidCallback onClearAll;
  
  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onSearchTapped,
    required this.onRemove,
    required this.onClearAll,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Searches',
              style: AppTypography.h5.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: onClearAll,
              child: Text(
                'Clear All',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ...recentSearches.map((search) => _buildSearchItem(search)),
      ],
    );
  }
  
  Widget _buildSearchItem(String search) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: () => onSearchTapped(search),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.history,
                size: AppSpacing.iconSm,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  search,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => onRemove(search),
                icon: Icon(
                  Icons.close,
                  size: AppSpacing.iconSm,
                  color: AppColors.textTertiary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}