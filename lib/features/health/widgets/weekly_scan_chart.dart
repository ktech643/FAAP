import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';

class WeeklyScanChart extends StatelessWidget {
  final Map<String, int> data;
  
  const WeeklyScanChart({
    super.key,
    required this.data,
  });
  
  @override
  Widget build(BuildContext context) {
    final maxValue = data.values.isEmpty 
        ? 10 
        : data.values.reduce((a, b) => a > b ? a : b).toDouble();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: AppShadows.cardShadow,
      ),
      child: BarChart(
        BarChartData(
          barGroups: _generateBarGroups(),
          maxY: maxValue + (maxValue * 0.2),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final days = data.keys.toList();
                  if (value.toInt() >= 0 && value.toInt() < days.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        days[value.toInt()],
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxValue > 5 ? 5 : 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.borderLight,
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: AppColors.gray800,
              tooltipRoundedRadius: AppSpacing.radiusMd,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final day = data.keys.toList()[group.x.toInt()];
                return BarTooltipItem(
                  '$day\n${rod.toY.toInt()} scans',
                  AppTypography.caption.copyWith(
                    color: AppColors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  
  List<BarChartGroupData> _generateBarGroups() {
    final days = data.keys.toList();
    return List.generate(days.length, (index) {
      final value = data[days[index]]?.toDouble() ?? 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: AppColors.primaryGreen,
            width: 20,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusSm),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 0,
              color: AppColors.gray100,
            ),
          ),
        ],
      );
    });
  }
}