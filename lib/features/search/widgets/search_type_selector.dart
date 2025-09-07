import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/search_provider.dart';

class SearchTypeSelector extends StatelessWidget {
  final SearchType selectedType;
  final Function(SearchType) onTypeChanged;
  
  const SearchTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: SearchType.values.map((type) {
          final isSelected = type == selectedType;
          return Padding(
            padding: EdgeInsets.only(
              right: type != SearchType.values.last ? AppSpacing.sm : 0,
            ),
            child: _buildTypeChip(
              label: _getTypeLabel(type),
              icon: _getTypeIcon(type),
              isSelected: isSelected,
              onTap: () => onTypeChanged(type),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildTypeChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.gray100,
          borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderLight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconSm,
              color: isSelected ? AppColors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _getTypeLabel(SearchType type) {
    switch (type) {
      case SearchType.all:
        return 'All';
      case SearchType.products:
        return 'Products';
      case SearchType.additives:
        return 'Additives';
      case SearchType.brands:
        return 'Brands';
    }
  }
  
  IconData _getTypeIcon(SearchType type) {
    switch (type) {
      case SearchType.all:
        return Icons.search;
      case SearchType.products:
        return Icons.shopping_basket;
      case SearchType.additives:
        return Icons.science;
      case SearchType.brands:
        return Icons.business;
    }
  }
}