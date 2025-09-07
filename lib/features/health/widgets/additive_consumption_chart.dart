import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';

class AdditiveConsumptionChart extends StatelessWidget {
  final Map<String, int> data;
  
  const AdditiveConsumptionChart({
    super.key,
    required this.data,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        children: [
          // Chart
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Pie Chart
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: _generateSections(),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                      pieTouchData: PieTouchData(
                        enabled: true,
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          // Handle touch
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xl),
                // Legend
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLegend(),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Info text
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: AppSpacing.iconSm,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Based on your scans this week',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  List<PieChartSectionData> _generateSections() {
    final total = data.values.reduce((a, b) => a + b);
    final colors = [
      AppColors.primaryRed,
      AppColors.primaryYellow,
      AppColors.primaryBlue,
      AppColors.primaryGreen,
      AppColors.warning,
    ];
    
    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percentage = (item.value / total * 100).round();
      
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: item.value.toDouble(),
        title: '$percentage%',
        radius: 60,
        titleStyle: AppTypography.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }
  
  List<Widget> _buildLegend() {
    final colors = [
      AppColors.primaryRed,
      AppColors.primaryYellow,
      AppColors.primaryBlue,
      AppColors.primaryGreen,
      AppColors.warning,
    ];
    
    return data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              item.key,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '(${item.value})',
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}