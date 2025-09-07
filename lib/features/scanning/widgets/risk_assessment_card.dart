import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';

class RiskAssessmentCard extends StatelessWidget {
  final String riskLevel;
  final int additiveCount;
  
  const RiskAssessmentCard({
    super.key,
    required this.riskLevel,
    required this.additiveCount,
  });
  
  String get _riskDescription {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return 'This product contains additives that may pose health risks. Consider finding alternatives.';
      case 'medium':
        return 'This product contains some additives that should be consumed in moderation.';
      case 'low':
        return 'This product has minimal additives and is generally safe for consumption.';
      default:
        return 'Risk level could not be determined.';
    }
  }
  
  IconData get _riskIcon {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Icons.warning_rounded;
      case 'medium':
        return Icons.info_rounded;
      case 'low':
        return Icons.check_circle_rounded;
      default:
        return Icons.help_rounded;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final riskColor = AppColors.getRiskColor(riskLevel);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: riskColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: riskColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _riskIcon,
                color: riskColor,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Assessment',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${riskLevel.toUpperCase()} RISK',
                      style: AppTypography.h5.copyWith(
                        color: riskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
                ),
                child: Text(
                  '$additiveCount additives',
                  style: AppTypography.bodySmall.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            _riskDescription,
            style: AppTypography.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}