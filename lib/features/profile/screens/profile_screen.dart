import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stat_tile.dart';
import '../widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return CustomScrollView(
            slivers: [
              // Profile Header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primaryGreen,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                    ),
                    child: SafeArea(
                      child: ProfileHeader(
                        userName: profileProvider.userName ?? 'Guest User',
                        userEmail: profileProvider.userEmail ?? 'guest@faapscan.com',
                        isPremium: profileProvider.isPremium,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Activity',
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
                            child: ProfileStatTile(
                              title: 'Total Scans',
                              value: profileProvider.totalScans.toString(),
                              icon: Icons.qr_code_scanner,
                              color: AppColors.primaryBlue,
                            )
                                .animate()
                                .fadeIn(delay: 300.ms)
                                .slideX(begin: -0.1, end: 0),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: ProfileStatTile(
                              title: 'Avoided',
                              value: profileProvider.avoidedAdditives.toString(),
                              subtitle: 'additives',
                              icon: Icons.block,
                              color: AppColors.warning,
                            )
                                .animate()
                                .fadeIn(delay: 400.ms)
                                .slideX(begin: 0.1, end: 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Premium Banner
              if (!profileProvider.isPremium)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: GestureDetector(
                      onTap: () => context.push(AppRoutes.premium),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryGreen,
                              AppColors.primaryGreen.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: Icon(
                                Icons.star,
                                color: AppColors.white,
                                size: AppSpacing.iconMd,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upgrade to Premium',
                                    style: AppTypography.body.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    'Unlock all features and get healthier',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.white,
                              size: AppSpacing.iconSm,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1, 1),
                      ),
                ),
              
              const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xl),
              ),
              
              // Menu Items
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 600.ms),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          boxShadow: AppShadows.cardShadow,
                        ),
                        child: Column(
                          children: [
                            ProfileMenuItem(
                              icon: Icons.person_outline,
                              title: 'Personal Information',
                              onTap: () => context.push(AppRoutes.settings),
                            )
                                .animate()
                                .fadeIn(delay: 700.ms)
                                .slideX(begin: 0.1, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                              icon: Icons.health_and_safety_outlined,
                              title: 'Health Preferences',
                              onTap: () => context.push(AppRoutes.settings),
                            )
                                .animate()
                                .fadeIn(delay: 800.ms)
                                .slideX(begin: 0.1, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                              icon: Icons.notifications_outlined,
                              title: 'Notifications',
                              onTap: () => context.push(AppRoutes.notifications),
                            )
                                .animate()
                                .fadeIn(delay: 900.ms)
                                .slideX(begin: 0.1, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                              icon: Icons.block_outlined,
                              title: 'Avoid List',
                              onTap: () => context.push(AppRoutes.avoidList),
                            )
                                .animate()
                                .fadeIn(delay: 1000.ms)
                                .slideX(begin: 0.1, end: 0),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      Text(
                        'About',
                        style: AppTypography.h5.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 1100.ms),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          boxShadow: AppShadows.cardShadow,
                        ),
                        child: Column(
                          children: [
                            ProfileMenuItem(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              onTap: () {},
                            )
                                .animate()
                                .fadeIn(delay: 1200.ms)
                                .slideX(begin: 0.1, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              onTap: () => context.push(AppRoutes.privacy),
                            )
                                .animate()
                                .fadeIn(delay: 1300.ms)
                                .slideX(begin: 0.1, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                              icon: Icons.description_outlined,
                              title: 'Terms of Service',
                              onTap: () => context.push(AppRoutes.terms),
                            )
                                .animate()
                                .fadeIn(delay: 1400.ms)
                                .slideX(begin: 0.1, end: 0),
                            const Divider(height: 1),
                            ProfileMenuItem(
                              icon: Icons.info_outline,
                              title: 'About FAAP Scan',
                              onTap: () => context.push(AppRoutes.about),
                            )
                                .animate()
                                .fadeIn(delay: 1500.ms)
                                .slideX(begin: 0.1, end: 0),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Sign Out Button
                      PrimaryButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text('Are you sure you want to sign out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    profileProvider.signOut();
                                    Navigator.pop(context);
                                    context.go(AppRoutes.onboarding);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                  ),
                                  child: const Text('Sign Out'),
                                ),
                              ],
                            ),
                          );
                        },
                        text: 'Sign Out',
                        icon: Icons.logout,
                        backgroundColor: AppColors.error,
                        width: double.infinity,
                      )
                          .animate()
                          .fadeIn(delay: 1600.ms),
                      
                      const SizedBox(height: AppSpacing.xxxl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}