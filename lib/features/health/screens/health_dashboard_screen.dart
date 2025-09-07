import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../providers/health_tracking_provider.dart';
import '../widgets/health_score_card.dart';
import '../widgets/weekly_scan_chart.dart';
import '../widgets/additive_consumption_chart.dart';
import '../widgets/health_insight_card.dart';
import '../widgets/health_stat_card.dart';
import '../models/health_data_model.dart';

class HealthDashboardScreen extends StatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  State<HealthDashboardScreen> createState() => _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthTrackingProvider>().refresh();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Consumer<HealthTrackingProvider>(
        builder: (context, healthProvider, _) {
          if (healthProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryGreen,
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: healthProvider.refresh,
            color: AppColors.primaryGreen,
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: AppColors.primaryGreen,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                'Your Health Dashboard',
                                style: AppTypography.h3.copyWith(
                                  color: AppColors.white,
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 300.ms),
                              const SizedBox(height: AppSpacing.xxl),
                              // Health Score
                              HealthScoreCard(
                                score: healthProvider.healthScore,
                                trend: healthProvider.trend,
                              )
                                  .animate()
                                  .scale(
                                    duration: 600.ms,
                                    curve: Curves.elasticOut,
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Stats Overview
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'This Week',
                          style: AppTypography.h5.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: HealthStatCard(
                                title: 'Total Scans',
                                value: healthProvider.totalScansThisWeek.toString(),
                                icon: Icons.qr_code_scanner,
                                color: AppColors.primaryBlue,
                              )
                                  .animate()
                                  .fadeIn(delay: 300.ms)
                                  .slideX(begin: -0.1, end: 0),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: HealthStatCard(
                                title: 'High Risk',
                                value: healthProvider.highRiskProductsThisWeek.toString(),
                                icon: Icons.warning,
                                color: AppColors.error,
                              )
                                  .animate()
                                  .fadeIn(delay: 400.ms)
                                  .slideX(begin: 0.1, end: 0),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: HealthStatCard(
                                title: 'Improvement',
                                value: '+${healthProvider.improvementPercentage}%',
                                icon: Icons.trending_up,
                                color: AppColors.success,
                              )
                                  .animate()
                                  .fadeIn(delay: 500.ms)
                                  .slideX(begin: -0.1, end: 0),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: HealthStatCard(
                                title: 'Avoided',
                                value: '${healthProvider.topHarmfulAdditives.length}',
                                subtitle: 'additives',
                                icon: Icons.block,
                                color: AppColors.warning,
                              )
                                  .animate()
                                  .fadeIn(delay: 600.ms)
                                  .slideX(begin: 0.1, end: 0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Weekly Scan Chart
                if (healthProvider.weeklyScans.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        'Weekly Activity',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 700.ms),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.md),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: WeeklyScanChart(
                        data: healthProvider.weeklyScans,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 800.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xl),
                  ),
                ],
                
                // Additive Consumption
                if (healthProvider.additiveConsumption.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Text(
                        'Top Additives This Week',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 900.ms),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.md),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: AdditiveConsumptionChart(
                        data: healthProvider.additiveConsumption,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 1000.ms)
                        .slideY(begin: 0.1, end: 0),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xl),
                  ),
                ],
                
                // Health Insights
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Text(
                      'Health Insights',
                      style: AppTypography.h5.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1100.ms),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.md),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    ...healthProvider.getHealthRecommendations().asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        child: HealthInsightCard(
                          insight: HealthInsight(
                            id: entry.key.toString(),
                            title: 'Recommendation',
                            description: entry.value,
                            type: InsightType.tip,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: Duration(milliseconds: 1200 + (entry.key * 100)))
                            .slideX(begin: 0.1, end: 0),
                      );
                    }),
                    
                    // Sample insights
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.sm,
                      ),
                      child: HealthInsightCard(
                        insight: HealthInsight(
                          id: 'achievement',
                          title: '🎉 Achievement Unlocked!',
                          description: 'You\'ve scanned 100+ products and are making healthier choices!',
                          type: InsightType.achievement,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1500.ms)
                          .slideX(begin: 0.1, end: 0),
                    ),
                    
                    if (healthProvider.healthScore < 70)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                        child: HealthInsightCard(
                          insight: HealthInsight(
                            id: 'warning',
                            title: '⚠️ Health Alert',
                            description: 'Your health score is below optimal. Consider reducing high-risk products.',
                            type: InsightType.warning,
                            actionText: 'View Tips',
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 1600.ms)
                            .slideX(begin: 0.1, end: 0),
                      ),
                  ]),
                ),
                
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xxxl),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}