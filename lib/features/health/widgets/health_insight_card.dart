import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../models/health_data_model.dart';

class HealthInsightCard extends StatelessWidget {
  final HealthInsight insight;
  final VoidCallback? onAction;
  
  const HealthInsightCard({
    super.key,
    required this.insight,
    this.onAction,
  });
  
  Color get _cardColor {
    switch (insight.type) {
      case InsightType.positive:
        return AppColors.success;
      case InsightType.warning:
        return AppColors.warning;
      case InsightType.tip:
        return AppColors.primaryBlue;
      case InsightType.achievement:
        return AppColors.primaryGreen;
    }
  }
  
  IconData get _cardIcon {
    switch (insight.type) {
      case InsightType.positive:
        return Icons.check_circle;
      case InsightType.warning:
        return Icons.warning;
      case InsightType.tip:
        return Icons.lightbulb;
      case InsightType.achievement:
        return Icons.emoji_events;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _cardColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: _cardColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _cardColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              _cardIcon,
              color: _cardColor,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  insight.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (insight.actionText != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  GestureDetector(
                    onTap: onAction,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                      ),
                      child: Text(
                        insight.actionText!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}