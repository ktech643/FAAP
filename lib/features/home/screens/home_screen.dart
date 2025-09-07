import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/database_service.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../scanning/models/scan_history_model.dart';
import '../../profile/providers/profile_provider.dart';
import '../widgets/health_score_widget.dart';
import '../widgets/recent_scan_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/recommendation_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ScanHistoryModel> _recentScans = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load recent scans
      final scans = await DatabaseService.instance.getScanHistory(limit: 5);
      
      if (mounted) {
        setState(() {
          _recentScans = scans;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading home data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final userName = profileProvider.userName ?? 'there';
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primaryGreen,
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello, $userName!',
                                style: AppTypography.h3.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Stay healthy, scan wisely',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => context.push(AppRoutes.notifications),
                            icon: Stack(
                              children: [
                                const Icon(
                                  Icons.notifications_outlined,
                                  size: 28,
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.error,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms),
              ),
              
              // Hero Section - Quick Scan
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(AppSpacing.lg),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGreen.withOpacity(0.3),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.qr_code_scanner,
                        size: 48,
                        color: AppColors.white,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Quick Scan',
                        style: AppTypography.h4.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Scan a product barcode to check its safety',
                        style: AppTypography.body.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      PrimaryButton(
                        onPressed: () => context.go(AppRoutes.scan),
                        text: 'Start Scanning',
                        icon: Icons.camera_alt,
                        backgroundColor: AppColors.white,
                        textColor: AppColors.primaryGreen,
                        width: double.infinity,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
              
              // Health Score Widget
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: HealthScoreWidget(
                    score: 78,
                    trend: 'improving',
                    onTap: () => context.go(AppRoutes.health),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
              ),
              
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
              
              // Quick Actions
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Actions',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: QuickActionCard(
                              icon: Icons.search,
                              title: 'Search',
                              subtitle: 'Find products',
                              color: AppColors.primaryBlue,
                              onTap: () => context.go(AppRoutes.search),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: QuickActionCard(
                              icon: Icons.history,
                              title: 'History',
                              subtitle: 'Past scans',
                              color: AppColors.primaryYellow,
                              onTap: () => context.push(AppRoutes.scanHistory),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: QuickActionCard(
                              icon: Icons.block,
                              title: 'Avoid List',
                              subtitle: 'Manage alerts',
                              color: AppColors.primaryRed,
                              onTap: () => context.push(AppRoutes.avoidList),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: QuickActionCard(
                              icon: Icons.star,
                              title: 'Premium',
                              subtitle: 'Unlock features',
                              color: AppColors.primaryGreen,
                              onTap: () => context.push(AppRoutes.premium),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 400.ms),
              ),
              
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
              
              // Recent Scans
              if (_recentScans.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Scans',
                          style: AppTypography.h5.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(AppRoutes.scanHistory),
                          child: Text(
                            'See All',
                            style: AppTypography.button.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: _recentScans.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index < _recentScans.length - 1
                                ? AppSpacing.md
                                : 0,
                          ),
                          child: RecentScanCard(
                            scan: _recentScans[index],
                            onTap: () {
                              // Navigate to product details
                              context.push(
                                '${AppRoutes.productDetails}/${_recentScans[index].barcode}',
                              );
                            },
                          ),
                        )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: 600 + (index * 100)),
                              duration: 400.ms,
                            )
                            .slideX(begin: 0.1, end: 0);
                      },
                    ),
                  ),
                ),
              ],
              
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
              
              // Recommendations
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'For You',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecommendationCard(
                        icon: Icons.lightbulb_outline,
                        title: 'Did you know?',
                        description: 'E102 (Tartrazine) is linked to hyperactivity in children. Check your favorite snacks!',
                        color: AppColors.primaryYellow,
                        onTap: () {
                          context.push('${AppRoutes.additiveDetails}/E102');
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      RecommendationCard(
                        icon: Icons.trending_up,
                        title: 'Health Tip',
                        description: 'You\'ve reduced harmful additives by 23% this week. Keep it up!',
                        color: AppColors.success,
                        onTap: () => context.go(AppRoutes.health),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 400.ms),
              ),
              
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxxl),
              ),
            ],
          ),
        ),
      ),
    );
  }
}