import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/profile_provider.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreen.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
                      Icon(
                        Icons.star,
                        size: 80,
                        color: AppColors.warning,
                      )
                          .animate()
                          .scale(
                            duration: 800.ms,
                            curve: Curves.elasticOut,
                          ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'FAAP Scan Premium',
                        style: AppTypography.h2.copyWith(
                          color: AppColors.white,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Unlock the full potential of healthy living',
                        style: AppTypography.body.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Features
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Features',
                    style: AppTypography.h4.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Feature list
                  _buildFeatureItem(
                    icon: Icons.search,
                    title: 'Find Healthier Alternatives',
                    description: 'Get personalized product recommendations based on your health goals',
                    delay: 600.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildFeatureItem(
                    icon: Icons.analytics,
                    title: 'Advanced Health Analytics',
                    description: 'Deep insights into your consumption patterns and health trends',
                    delay: 700.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildFeatureItem(
                    icon: Icons.family_restroom,
                    title: 'Family Profiles',
                    description: 'Manage health preferences for your entire family',
                    delay: 800.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildFeatureItem(
                    icon: Icons.download,
                    title: 'Export Health Reports',
                    description: 'Download detailed reports to share with healthcare providers',
                    delay: 900.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildFeatureItem(
                    icon: Icons.notifications_active,
                    title: 'Smart Alerts',
                    description: 'Get notified about recalls and health warnings for scanned products',
                    delay: 1000.ms,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildFeatureItem(
                    icon: Icons.all_inclusive,
                    title: 'Unlimited Scans',
                    description: 'No daily limits on product scanning',
                    delay: 1100.ms,
                  ),
                  
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Pricing
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      border: Border.all(
                        color: AppColors.primaryGreen,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Choose Your Plan',
                          style: AppTypography.h5.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Monthly Plan
                        _buildPlanOption(
                          title: 'Monthly',
                          price: '\$4.99',
                          period: 'per month',
                          isPopular: false,
                        ),
                        
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Annual Plan
                        _buildPlanOption(
                          title: 'Annual',
                          price: '\$39.99',
                          period: 'per year',
                          savings: 'Save 33%',
                          isPopular: true,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 1200.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Subscribe Button
                  PrimaryButton(
                    onPressed: profileProvider.isPremium
                        ? null
                        : () {
                            // Handle subscription
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Coming Soon'),
                                content: const Text(
                                  'Premium subscriptions will be available soon!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                    text: profileProvider.isPremium
                        ? 'You\'re Already Premium!'
                        : 'Start Free Trial',
                    icon: Icons.star,
                    width: double.infinity,
                    height: 56,
                  )
                      .animate()
                      .fadeIn(delay: 1300.ms),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Terms
                  Text(
                    'Start with a 7-day free trial. Cancel anytime.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  )
                      .animate()
                      .fadeIn(delay: 1400.ms),
                  
                  const SizedBox(height: AppSpacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Duration delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay)
        .slideX(begin: 0.1, end: 0);
  }
  
  Widget _buildPlanOption({
    required String title,
    required String price,
    required String period,
    String? savings,
    required bool isPopular,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isPopular ? AppColors.primaryGreen.withOpacity(0.05) : AppColors.gray50,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isPopular ? AppColors.primaryGreen : AppColors.borderLight,
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isPopular)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              ),
              child: Text(
                'MOST POPULAR',
                style: AppTypography.caption.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (isPopular) const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppTypography.h5.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: AppTypography.h3.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                period,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (savings != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
              ),
              child: Text(
                savings,
                style: AppTypography.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}